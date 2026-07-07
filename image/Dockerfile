# hadolint global ignore=DL3008,DL3013
FROM ubuntu:24.04

ARG TARGETARCH
ARG GO_VERSION=1.25.0

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ansible \
      bash \
      build-essential \
      ca-certificates \
      curl \
      dnsutils \
      git \
      gnupg \
      gzip \
      iputils-ping \
      jq \
      less \
      nano \
      netcat-openbsd \
      nodejs \
      npm \
      openssh-client \
      python3 \
      python3-pip \
      python3-venv \
      sudo \
      tar \
      unzip \
      vim \
      wget \
      zsh \
      iproute2 \
      iptables \
      libcap2-bin \
      wireguard-tools \
    && rm -rf /var/lib/apt/lists/*

# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

# Go
RUN case "${TARGETARCH}" in \
      amd64) GO_ARCH="amd64" ;; \
      arm64) GO_ARCH="arm64" ;; \
      *) echo "Unsupported architecture for Go: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/go.tar.gz \
      "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm -f /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/coder/go"

# kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl \
      "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl" \
    && chmod +x /usr/local/bin/kubectl

# Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Flux CLI
RUN curl -fsSL https://fluxcd.io/install.sh | bash

# kustomize
RUN curl -fsSL https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh \
    | bash -s -- /usr/local/bin

# sops
RUN case "${TARGETARCH}" in \
      amd64) SOPS_ARCH="amd64" ;; \
      arm64) SOPS_ARCH="arm64" ;; \
      *) echo "Unsupported architecture for sops: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/sops \
      "https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.${SOPS_ARCH}" \
    && chmod +x /usr/local/bin/sops

# age
RUN case "${TARGETARCH}" in \
      amd64) AGE_ARCH="amd64" ;; \
      arm64) AGE_ARCH="arm64" ;; \
      *) echo "Unsupported architecture for age: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/age.tar.gz \
      "https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-linux-${AGE_ARCH}.tar.gz" \
    && mkdir -p /tmp/age \
    && tar -xzf /tmp/age.tar.gz -C /tmp/age --strip-components=1 \
    && mv /tmp/age/age /tmp/age/age-keygen /usr/local/bin/ \
    && chmod +x /usr/local/bin/age /usr/local/bin/age-keygen \
    && rm -rf /tmp/age /tmp/age.tar.gz

# yq
RUN case "${TARGETARCH}" in \
      amd64) YQ_ARCH="amd64" ;; \
      arm64) YQ_ARCH="arm64" ;; \
      *) echo "Unsupported architecture for yq: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/yq \
      "https://github.com/mikefarah/yq/releases/download/v4.44.6/yq_linux_${YQ_ARCH}" \
    && chmod +x /usr/local/bin/yq

# k9s
RUN case "${TARGETARCH}" in \
      amd64) K9S_ARCH="amd64" ;; \
      arm64) K9S_ARCH="arm64" ;; \
      *) echo "Unsupported architecture for k9s: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/k9s.tar.gz \
      "https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Linux_${K9S_ARCH}.tar.gz" \
    && tar -xzf /tmp/k9s.tar.gz -C /tmp \
    && mv /tmp/k9s /usr/local/bin/k9s \
    && chmod +x /usr/local/bin/k9s \
    && rm -f /tmp/k9s.tar.gz

# GitHub CLI
RUN mkdir -p /etc/apt/keyrings \
    && chmod 755 /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Coder workspace user
# Ubuntu 24.04 images may already include an ubuntu user at UID 1000.
# Our Terraform runs the workspace as UID/GID 1000 and expects /home/coder,
# so make UID/GID 1000 belong to coder.
RUN if id ubuntu >/dev/null 2>&1; then userdel -r ubuntu || true; fi \
    && if getent group ubuntu >/dev/null 2>&1; then groupdel ubuntu || true; fi \
    && groupadd --gid 1000 coder \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-coder \
    && chmod 0440 /etc/sudoers.d/90-coder \
    && mkdir -p /home/coder/.local/bin /home/coder/workspace /home/coder/go \
    && chown -R coder:coder /home/coder

COPY scripts/verify-tools.sh /usr/local/bin/verify-tools

RUN chmod +x /usr/local/bin/verify-tools

USER coder

ENV PATH="/usr/local/go/bin:/home/coder/go/bin:/home/coder/.local/bin:${PATH}"
ENV GOPATH="/home/coder/go"
ENV UV_LINK_MODE=copy

WORKDIR /home/coder

CMD ["/bin/bash"]
