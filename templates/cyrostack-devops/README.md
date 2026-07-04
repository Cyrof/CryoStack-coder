# CyroStack DevOps Coder Template

This Coder template provisions a Kubernetes-based DevOps workspace for CyroStack.

Each workspace gets:

- A dedicated Kubernetes Deployment
- A dedicated PVC mounted at `/home/coder`
- Browser VS Code through code-server
- The `ghcr.io/cyrof/cyrostack-coder` workspace image
- Full k3s cluster access through the `coder-workspace-admin` ServiceAccount

## Expected Kubernetes Resources

The Coder Helm chart should create these resources before this template is used:

- Namespace: `coder-workspaces`
- ServiceAccount: `coder-workspace-admin`
- ClusterRoleBinding: `coder-workspace-admin` to `cluster-admin`

## Push Template

Log in to your local Coder instance:

```bash
coder login http://coder.cyrostack.arpa
```

Push the template:

```bash
cd templates/cyrostack-devops
coder templates push cyrostack-devops
```

## Create Workspaces

Create one workspace for each user from the Coder UI:

| User    | Workspace Name |
| ------- | -------------- |
| Keith   | `devops`       |
| Partner | `devops`       |

The environments are separated by workspace ID. Each user gets their own pod and PVC.

## Workspace Separation

Although both users use the same Coder template and image, each workspace is separate.

Example:

```text
Keith workspace:
  Pod: coder-<keith-workspace-id>
  PVC: home-<keith-workspace-id>
  Home directory: /home/coder

Partner workspace:
  Pod: coder-<partner-workspace-id>
  PVC: home-<partner-workspace-id>
  Home directory: /home/coder
```

## Included Tools

The workspace image is expected to include:

- `code-server`
- `kubectl`
- `flux`
- `helm`
- `kustomize`
- `sops`
- `age`
- `gh`
- `k9s`
- `jq`
- `yq`
- Go
- Python
- `uv`
- Node.js and npm
- Ansible

## Cluster Access

Both Keith and partner workspaces use the same admin ServiceAccount:

```text
coder-workspace-admin
```

This ServiceAccount should be bound to the Kubernetes `cluster-admin` ClusterRole.

Required Kubernetes resources:

```yaml
apiVersion: v1
kind: Namespace
metadata:
    name: coder-workspaces
---
apiVersion: v1
kind: ServiceAccount
metadata:
    name: coder-workspace-admin
    namespace: coder-workspaces
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: coder-workspace-admin
subjects:
    - kind: ServiceAccount
      name: coder-workspace-admin
      namespace: coder-workspaces
roleRef:
    kind: ClusterRole
    name: cluster-admin
    apiGroup: rbac.authorization.k8s.io
```

## Template Variables

The template currently supports the following variables:

| Variable               |                                Default | Description                                               |
| ---------------------- | -------------------------------------: | --------------------------------------------------------- |
| `namespace`            |                     `coder-workspaces` | Namespace where workspace resources are created           |
| `service_account_name` |                `coder-workspace-admin` | ServiceAccount used by workspace pods                     |
| `workspace_image`      | `ghcr.io/cyrof/cyrostack-coder:latest` | Image used for the DevOps workspace                       |
| `storage_class_name`   |                              `nfs-csi` | StorageClass used for workspace PVCs                      |
| `use_kubeconfig`       |                                `false` | Whether to use host kubeconfig instead of in-cluster auth |

## Resource Parameters

When creating a workspace, users can choose:

| Parameter      | Options                |
| -------------- | ---------------------- |
| CPU            | `1`, `2`, or `4` cores |
| Memory         | `2`, `4`, or `8` GiB   |
| Home disk size | `5` to `200` GiB       |

## Local Validation

Format the Terraform files:

```bash
terraform fmt -recursive templates
```

Validate the template:

```bash
cd templates/cyrostack-devops
terraform init -backend=false
terraform validate
```

## Notes

This template assumes the Coder platform, workspace namespace, and workspace RBAC have already been deployed by the Helm chart.

This template only creates per-workspace resources such as:

- PersistentVolumeClaim
- Deployment
- Coder agent
- Coder VS Code app
