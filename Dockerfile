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
RUN brew install \
  node \
  pnpm \
  goenv \
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
  fish \
  docker

USER root

SHELL ["/home/linuxbrew/.linuxbrew/bin/fish", "-c"]

RUN lla theme pull

ENV SHELL=fish

RUN pnpm setup

## Install Cody cli
RUN pnpm install -g @sourcegraph/cody

## Install Go
RUN goenv install 1.24.1 && goenv global 1.24.1

## Go packages

## Rust packages

# Set working directory
WORKDIR /root

COPY config/ /root/.config/
##COPY nvim/mason/ /root/.local/share/nvim/mason/
## Initialise nvim/lazy vim
RUN nvim --headless -c "Lazy! sync" -c "Lazy update" -c "qa"

# Command to run when container starts
CMD ["fish"]
