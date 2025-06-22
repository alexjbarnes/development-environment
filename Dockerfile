FROM debian:bookworm-slim

RUN ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo Europe/London > /etc/timezone

## Apt packages
RUN apt-get update && apt-get install -y curl git build-essential locales

## Install Homebrew
RUN useradd -m -s /bin/zsh linuxbrew && \
  usermod -aG sudo linuxbrew &&  \
  mkdir -p /home/linuxbrew/.linuxbrew && \
  chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
USER root
RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew

## Brew Packages
USER linuxbrew
RUN brew update

# Install all package managers first
RUN brew install \
  node \
  pnpm \
  goenv \
  fish

USER root

RUN goenv install 1.24.1 && goenv global 1.24.1

RUN  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

SHELL ["/home/linuxbrew/.linuxbrew/bin/fish", "-c"]

ENV SHELL=fish

RUN pnpm setup

## Install Cody cli
RUN pnpm install -g @sourcegraph/cody

## Go packages

## Rust packages

## Brew Packages
USER linuxbrew
RUN brew install \
  ripgrep \
  television \
  jesseduffield/lazygit/lazygit \
  btop \
  knqyf263/pet/pet \
  opentofu \
  lla \
  tlrc \
  nvim \
  fd \
  docker

USER root

WORKDIR /root

COPY config/ /root/.config/

RUN lla theme pull

CMD ["fish"]
