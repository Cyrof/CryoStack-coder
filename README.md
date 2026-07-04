<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->

<p align="center">
  <a href="https://github.com/cyrof/cyrostack-coder/actions/workflows/ci.yaml">
    <img
      src="https://img.shields.io/github/actions/workflow/status/cyrof/cyrostack-coder/ci.yaml?branch=dev&style=for-the-badge&label=CI"
      alt="CI Status"
    >
  </a>
  <a href="https://github.com/cyrof/cyrostack-coder/actions/workflows/lint.yaml">
    <img src="https://img.shields.io/github/actions/workflow/status/cyrof/cyrostack-coder/lint.yaml?branch=dev&style=for-the-badge&label=Lint" alt="Lint Status">
  </a>
  <a href="https://github.com/cyrof/cyrostack-coder/releases">
    <img src="https://img.shields.io/github/v/release/cyrof/cyrostack-coder?style=for-the-badge" alt="Latest Release">
  </a>
  <a href="https://github.com/cyrof/cyrostack-coder/blob/stable/LICENSE">
    <img src="https://img.shields.io/github/license/cyrof/cyrostack-coder?style=for-the-badge" alt="License">
  </a>
  <a href="https://github.com/cyrof/cyrostack-coder/pkgs/container/cyrostack-coder">
    <img src="https://img.shields.io/badge/GHCR-cyrostack--coder-blue?style=for-the-badge" alt="GHCR Image">
  </a>
</p>

<br />

<div align="center">
  <h1>CyroStack Coder</h1>

  <p align="center">
    Coder platform, workspace image, and DevOps workspace templates for CyroStack.
    <br />
    <br />
    <a
      href="https://github.com/cyrof/cyrostack-coder/issues/new?labels=bug&template=bug_report.md"
    >
  Report Bug
</a>
    &middot;
    <a href="https://github.com/cyrof/cyrostack-coder/issues/new?labels=enhancement&template=feature_request.md">Request Feature</a>
    &middot;
    <a href="https://github.com/cyrof/cyrostack-coder/releases">Releases</a>
  </p>
</div>

---

<!-- TABLE OF CONTENTS -->

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#what-it-does">What It Does</a></li>
        <li><a href="#repository-structure">Repository Structure</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#helm-chart">Helm Chart</a></li>
    <li><a href="#workspace-image">Workspace Image</a></li>
    <li><a href="#coder-template">Coder Template</a></li>
    <li><a href="#testing">Testing</a></li>
    <li><a href="#release-flow">Release Flow</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

---

## About The Project

**CyroStack Coder** provides the Coder platform components used to run browser-based DevOps workspaces
for the CyroStack home cluster.

This repository contains:

- A Helm chart for deploying Coder and its supporting Kubernetes resources.
- A custom Coder workspace image with DevOps and development tools preinstalled.
- A Coder Terraform template for creating isolated Kubernetes-based workspaces.
- CI/CD workflows for linting, build validation, release preparation, and release packaging.

The intended deployment target is a local k3s cluster, accessed through VPN and local DNS using:

```text
coder.cyrostack.arpa
*.coder.cyrostack.arpa
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## What It Does

CyroStack Coder currently provides:

- Local-only Coder deployment through a Helm chart.
- PostgreSQL deployment as a chart dependency.
- Workspace namespace and RBAC bootstrap.
- A full-access workspace ServiceAccount for DevOps operations.
- A custom workspace image with Kubernetes, Flux, Helm, Go, Python, uv, and VS Code/code-server tooling.
- A Coder Terraform template for per-user workspaces.
- Separate workspace pods and PVCs for each Coder user.
- CI checks for YAML, Markdown, Helm, Terraform, Dockerfile, shell scripts, and image builds.
- Controlled release flow from `dev` to `stable`.

The primary users are Keith and partner, with both workspaces intended to have full k3s cluster access.

---

## Repository Structure

```text
cyrostack-coder/
├── chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│
├── image/
│   ├── Dockerfile
│   └── scripts/
│
├── templates/
│   └── cyrostack-devops/
│       ├── main.tf
│       └── README.md
│
└── .github/
    └── workflows/
```

| Path                 | Purpose                                              |
| -------------------- | ---------------------------------------------------- |
| `chart/`             | Helm chart used by Flux to deploy the Coder platform |
| `image/`             | Custom Coder workspace image build context           |
| `templates/`         | Coder Terraform workspace templates                  |
| `.github/workflows/` | CI, linting, image build, and release workflows      |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Built With

<p align="left">
  <img src="https://img.shields.io/badge/Coder-000000?style=for-the-badge&logo=coder&logoColor=white" alt="Coder">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes">
  <img src="https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white" alt="Helm">
  <img src="https://img.shields.io/badge/Flux-5468FF?style=for-the-badge&logo=flux&logoColor=white" alt="Flux">
  <img src="https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform">
  <img src="https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white" alt="GitHub Actions">
</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Getting Started

### Prerequisites

Install the following tools for local development:

- Docker
- Helm 3
- Terraform
- kubectl
- Coder CLI
- yamllint
- markdownlint-cli2
- ShellCheck

Optional but recommended:

- `make`
- `gh`
- `hadolint`

---

### Installation

Clone the repository:

```bash
git clone git@github.com:cyrof/cyrostack-coder.git
cd cyrostack-coder
```

Checkout the development branch:

```bash
git checkout dev
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Helm Chart

The Helm chart is located in:

```text
chart/
```

It is intended to be consumed by the CyroStack Flux repository as a submodule chart.

The chart is responsible for deploying or configuring:

- Coder
- PostgreSQL
- Workspace namespace
- Workspace admin ServiceAccount
- Workspace ClusterRoleBinding

Expected local Coder URL:

```text
http://coder.cyrostack.arpa
```

Expected wildcard workspace URL:

```text
*.coder.cyrostack.arpa
```

### Required Secrets

Secrets are intentionally not stored in this repository.

The Flux repo should create these secrets using SOPS:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: coder-postgresql-secret
    namespace: coder
type: Opaque
stringData:
    postgres-password: "<admin-password>"
    password: "<coder-db-password>"
---
apiVersion: v1
kind: Secret
metadata:
    name: coder-db-url
    namespace: coder
type: Opaque
stringData:
    url: "postgres://coder:<coder-db-password>@coder-postgresql.coder.svc.cluster.local:5432/coder?sslmode=disable"
```

### Validate Chart

```bash
helm repo add coder https://helm.coder.com/v2
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm dependency build chart
helm lint chart
helm template cyrostack-coder chart --namespace coder --values chart/values.yaml
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Workspace Image

The workspace image is located in:

```text
image/
```

The image is published to GitHub Container Registry:

```text
ghcr.io/cyrof/cyrostack-coder
```

The image includes:

- code-server
- kubectl
- flux
- helm
- kustomize
- sops
- age
- gh
- k9s
- jq
- yq
- Go
- Python
- uv
- Node.js and npm
- Ansible

### Build Locally

```bash
docker build -t cyrostack-coder:test ./image/
```

If local Docker networking has DNS issues, build with host networking:

```bash
docker build --network=host -t cyrostack-coder:test ./image/
```

### Verify Tools

```bash
docker run --rm cyrostack-coder:test verify-tools
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Coder Template

The Coder workspace template is located in:

```text
templates/cyrostack-devops/
```

The template provisions one isolated Kubernetes workspace per Coder user.

Each workspace gets:

- A dedicated Kubernetes Deployment.
- A dedicated PVC mounted at `/home/coder`.
- Browser VS Code through code-server.
- The `ghcr.io/cyrof/cyrostack-coder` workspace image.
- Full k3s cluster access through the `coder-workspace-admin` ServiceAccount.

### Push Template

After Coder is deployed and reachable:

```bash
coder login http://coder.cyrostack.arpa
cd templates/cyrostack-devops
coder templates push cyrostack-devops
```

### Create Workspaces

Create one workspace for each user from the Coder UI:

| User    | Workspace Name |
| ------- | -------------- |
| Keith   | `devops`       |
| Partner | `devops`       |

Both users use the same template and image, but each workspace gets its own pod and PVC.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Testing

Run YAML lint:

```bash
yamllint .
```

Run Terraform formatting:

```bash
terraform fmt -check -recursive templates
```

Validate the Coder template:

```bash
cd templates/cyrostack-devops
terraform init -backend=false
terraform validate
```

Lint and render the Helm chart:

```bash
helm dependency build chart
helm lint chart
helm template cyrostack-coder chart --namespace coder --values chart/values.yaml
```

Build the workspace image:

```bash
docker build -t cyrostack-coder:test ./image/
```

Verify workspace tools:

```bash
docker run --rm cyrostack-coder:test verify-tools
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Release Flow

This repository uses a controlled release flow:

```text
dev -> release/vX.Y.Z -> stable
```

The release process is:

1. Merge feature or refactor branches into `dev`.
2. Run the `prepare-release` workflow manually.
3. Select the version bump type: `patch`, `minor`, or `major`.
4. The workflow creates a `release/vX.Y.Z` branch.
5. The workflow updates `CHANGELOG.md` and `chart/Chart.yaml`.
6. Review and update the generated changelog entry.
7. Merge the release PR into `stable`.
8. The `release` workflow creates the Git tag and GitHub Release.
9. The release workflow builds and publishes the GHCR image.
10. The release workflow packages the Helm chart artifact.

Release branches are intentionally skipped by normal lint and CI workflows.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Roadmap

- [x] Initial custom Coder workspace image
- [x] Initial Coder Terraform workspace template
- [x] Initial Helm chart for Coder platform deployment
- [x] CI validation for linting, Helm, Terraform, and Docker build checks
- [x] Release workflow for GHCR image and Helm chart packaging
- [ ] Flux deployment manifests in CyroStack home cluster repo
- [ ] Internal TLS support for `coder.cyrostack.arpa`
- [ ] Automated Coder template publishing from a self-hosted runner
- [ ] Optional per-user workspace parameters for image tag and storage size
- [ ] Observability dashboards for Coder and workspace resource usage

See the [open issues](https://github.com/cyrof/cyrostack-coder/issues) for planned improvements and known issues.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions are welcome.

For normal development:

1. Create a feature or refactor branch from `dev`.

    ```bash
    git checkout dev
    git pull
    git checkout -b feature/your-feature-name
    ```

2. Make your changes.

3. Run validations.

    ```bash
    yamllint .
    terraform fmt -check -recursive templates
    helm lint chart
    docker build -t cyrostack-coder:test ./image/
    ```

4. Commit using conventional commit style.

    ```bash
    git commit -m "feat: add coder platform capability"
    ```

5. Open a pull request into `dev`.

For release preparation, use the release workflow instead of manually creating tags.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## License

Distributed under the Apache License 2.0. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contact

Project Owner: [cyrof](https://github.com/cyrof)

Repository: [cyrof/cyrostack-coder](https://github.com/cyrof/cyrostack-coder)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
