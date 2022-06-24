# You can pick any Debian/Ubuntu-based image. 😊
FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

COPY library-scripts/*.sh /tmp/library-scripts/

# [Option] Install zsh
ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="yes"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \ 
    && apt-get install -y \
        make \
        graphviz \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Terraform, tflint, Terragrunt
ARG TERRAFORM_VERSION=0.12.31
ARG TFLINT_VERSION=0.8.2
ARG TERRAGRUNT_VERSION=0.28.1
RUN bash /tmp/library-scripts/terraform-debian.sh "${TERRAFORM_VERSION}" "${TFLINT_VERSION}" "${TERRAGRUNT_VERSION}" \
    && rm -rf /tmp/library-scripts

CMD [ "sleep", "infinity" ]
