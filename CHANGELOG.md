# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

---

## [v1.0.1] - 2026-07-05

### Added

- No addition in this release.

### Changed

- No changes in this release.

### Fixed

- Fixed name typo.

### Removed

- No removals in this release.

## [v1.0.0] - 2026-07-04

### Added

- Added the initial CyroStack Coder platform Helm chart.
- Added Coder and PostgreSQL as Helm chart dependencies.
- Added local-only Coder ingress configuration for `coder.cyrostack.arpa`.
- Added wildcard workspace routing configuration for `*.coder.cyrostack.arpa`.
- Added workspace namespace bootstrap for `coder-workspaces`.
- Added `coder-workspace-admin` ServiceAccount with `cluster-admin` access for DevOps workspaces.
- Added the custom Coder workspace image under `image/`.
- Added preinstalled DevOps and development tooling to the workspace image, including:
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
- Added `verify-tools.sh` to validate required tools inside the workspace image.
- Added the initial Coder Terraform workspace template under `templates/cyrostack-devops/`.
- Added per-workspace Kubernetes Deployment and PVC provisioning through the Coder template.
- Added browser VS Code/code-server access through the Coder app definition.
- Added configurable workspace CPU, memory, and home disk parameters.
- Added CI workflows for linting, Helm validation, Terraform validation, and Docker build checks.
- Added release workflows for preparing releases, creating GitHub Releases, publishing the GHCR image, and packaging the Helm chart.
- Added project documentation, README, license, and initial changelog.

### Changed

- Replaced the placeholder Helm chart with the initial deployable CyroStack Coder chart.
- Updated Markdown lint configuration to support badge-heavy README formatting.
- Updated Helm CI workflows to add required chart repositories before dependency builds.

### Fixed

- Fixed Dockerfile lint issues reported by Hadolint.
- Fixed Terraform formatting issues for the Coder workspace template.
- Fixed Markdown lint issues in README and template documentation.
- Fixed Helm dependency build failures in CI by adding required Helm repositories.

### Removed

- Removed the placeholder Helm ConfigMap from the initial chart scaffold.
