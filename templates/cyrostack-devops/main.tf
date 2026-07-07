terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "coder" {}

provider "kubernetes" {
  # false = use in-cluster Kubernetes auth from the Coder provisioner.
  # true  = use ~/.kube/config on the provisioner host.
  config_path = var.use_kubeconfig ? "~/.kube/config" : null
}

variable "use_kubeconfig" {
  type        = bool
  description = "Use host kubeconfig instead of in-cluster Kubernetes authentication."
  default     = false
}

variable "namespace" {
  type        = string
  description = "Namespace where Coder workspace resources are created."
  default     = "coder-workspaces"
}

variable "service_account_name" {
  type        = string
  description = "ServiceAccount used by workspace pods. This should have cluster-admin access for CyroStack."
  default     = "coder-workspace-admin"
}

variable "workspace_image" {
  type        = string
  description = "Workspace image used for the Coder DevOps environment."
  default     = "ghcr.io/cyrof/cyrostack-coder:latest"
}

variable "storage_class_name" {
  type        = string
  description = "StorageClass used for persistent workspace home directories."
  default     = "nfs-csi"
}

data "coder_workspace" "me" {}

data "coder_workspace_owner" "me" {}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "CPU limit for the workspace."
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true

  option {
    name  = "1 Core"
    value = "1"
  }

  option {
    name  = "2 Cores"
    value = "2"
  }

  option {
    name  = "4 Cores"
    value = "4"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "Memory limit for the workspace."
  default      = "4"
  icon         = "/icon/memory.svg"
  mutable      = true

  option {
    name  = "2 GiB"
    value = "2"
  }

  option {
    name  = "4 GiB"
    value = "4"
  }

  option {
    name  = "8 GiB"
    value = "8"
  }
}

data "coder_parameter" "home_disk_size" {
  name         = "home_disk_size"
  display_name = "Home disk size"
  description  = "Persistent home disk size in GiB."
  default      = "20"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false

  validation {
    min = 5
    max = 200
  }
}

locals {
  workspace_labels = {
    "app.kubernetes.io/name"    = "coder-workspace"
    "app.kubernetes.io/part-of" = "cyrostack-coder"
    "com.coder.resource"        = "true"
    "com.coder.workspace.id"    = data.coder_workspace.me.id
    "com.coder.workspace.name"  = data.coder_workspace.me.name
    "com.coder.user.id"         = data.coder_workspace_owner.me.id
    "com.coder.user.username"   = data.coder_workspace_owner.me.name
  }

  workspace_annotations = {
    "com.coder.user.email" = data.coder_workspace_owner.me.email
  }

  instance_name = "coder-${data.coder_workspace.me.id}"
  home_pvc_name = "home-${data.coder_workspace.me.id}"
}

resource "coder_agent" "main" {
  os   = "linux"
  arch = "arm64"

  startup_script = <<-EOT
    set -e

    mkdir -p /home/coder/workspace
    mkdir -p /home/coder/.config/code-server

    cat > /home/coder/.config/code-server/config.yaml <<EOF
    bind-addr: 127.0.0.1:13337
    auth: none
    cert: false
    EOF

    code-server --bind-addr 127.0.0.1:13337 /home/coder/workspace > /tmp/code-server.log 2>&1 &

    echo "CyroStack Coder workspace ready."
    echo
    echo "User: $(whoami)"
    echo "Home: $HOME"
    echo
    echo "Tool versions:"
    kubectl version --client=true || true
    flux --version || true
    helm version --short || true
    kustomize version || true
    sops --version || true
    age --version || true
    go version || true
    uv --version || true
    python3 --version || true
  EOT

  metadata {
    key          = "0_cpu"
    display_name = "CPU usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    key          = "1_memory"
    display_name = "Memory usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    key          = "2_home_disk"
    display_name = "Home disk"
    script       = "coder stat disk --path /home/coder"
    interval     = 60
    timeout      = 1
  }

  metadata {
    key          = "3_kubectl"
    display_name = "kubectl"
    script       = "kubectl version --client=true --output=yaml | head -20"
    interval     = 300
    timeout      = 10
  }

  metadata {
    key          = "4_flux"
    display_name = "Flux"
    script       = "flux --version"
    interval     = 300
    timeout      = 10
  }
}

resource "coder_app" "code_server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "VS Code"
  icon         = "/icon/code.svg"
  url          = "http://localhost:13337/?folder=/home/coder/workspace"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "kubernetes_persistent_volume_claim_v1" "home" {
  metadata {
    name        = local.home_pvc_name
    namespace   = var.namespace
    labels      = local.workspace_labels
    annotations = local.workspace_annotations
  }

  wait_until_bound = false

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name

    resources {
      requests = {
        storage = "${data.coder_parameter.home_disk_size.value}Gi"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
    ]
  }
}

resource "kubernetes_deployment_v1" "workspace" {
  count = data.coder_workspace.me.start_count

  depends_on = [
    kubernetes_persistent_volume_claim_v1.home,
  ]

  wait_for_rollout = false

  metadata {
    name        = local.instance_name
    namespace   = var.namespace
    labels      = local.workspace_labels
    annotations = local.workspace_annotations
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "coder-workspace"
        "com.coder.workspace.id" = data.coder_workspace.me.id
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels      = local.workspace_labels
        annotations = local.workspace_annotations
      }

      spec {
        service_account_name = var.service_account_name

        security_context {
          run_as_user     = 1000
          run_as_group    = 1000
          fs_group        = 1000
          run_as_non_root = true
        }

        container {
          name              = "dev"
          image             = var.workspace_image
          image_pull_policy = "Always"
          command           = ["sh", "-c", coder_agent.main.init_script]

          security_context {
            run_as_user                = 1000
            run_as_group               = 1000
            allow_privilege_escalation = true
            read_only_root_filesystem  = false
            privileged                 = true

            capabilities {
              add = [
                "NET_ADMIN",
                "NET_RAW",
              ]
            }
          }

          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }

          env {
            name  = "HOME"
            value = "/home/coder"
          }

          env {
            name  = "GOPATH"
            value = "/home/coder/go"
          }

          env {
            name  = "UV_LINK_MODE"
            value = "copy"
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "1Gi"
            }

            limits = {
              cpu    = data.coder_parameter.cpu.value
              memory = "${data.coder_parameter.memory.value}Gi"
            }
          }

          volume_mount {
            name       = "home"
            mount_path = "/home/coder"
            read_only  = false
          }

          volume_mount {
            name       = "dev-net-tun"
            mount_path = "/dev/net/tun"
            read_only  = false
          }
        }

        volume {
          name = "home"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.home.metadata[0].name
            read_only  = false
          }
        }

        volume {
          name = "dev-net-tun"

          host_path {
            path = "/dev/net/tun"
            type = "CharDevice"
          }
        }
      }
    }
  }
}
