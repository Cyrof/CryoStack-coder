#!/usr/bin/env bash

set -euo pipefail

echo "Checking CyroStack Coder workspace tools..."
echo

check_tool() {
  local tool="$1"

  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool"
    exit 1
  fi

  echo "Found: $tool"
}

check_tool git
check_tool gh
check_tool kubectl
check_tool flux
check_tool helm
check_tool kustomize
check_tool sops
check_tool age
check_tool age-keygen
check_tool yq
check_tool jq
check_tool k9s
check_tool code-server
check_tool python3
check_tool node
check_tool npm
check_tool ansible
check_tool go
check_tool uv

echo
echo "Versions:"
git --version
gh --version | head -n 1
kubectl version --client=true
flux --version
helm version --short
kustomize version
sops --version
age --version
yq --version
jq --version
k9s version --short || true
code-server --version | head -n 1
python3 --version
node --version
npm --version
ansible --version | head -n 1
go version
uv --version

echo
echo "All required tools are available."
