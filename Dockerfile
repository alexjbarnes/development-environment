FROM debian:bookworm-slim

RUN ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo Europe/London > /etc/timezone

## Apt packages
RUN apt-get update && \
  apt-get install -y --no-install-recommends curl git build-essential locales ca-certificates sudo && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

## Install Homebrew
RUN useradd -m -s /bin/bash linuxbrew && \
  usermod -aG sudo linuxbrew &&  \
  mkdir -p /home/linuxbrew/.linuxbrew && \
  chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
USER root
RUN chown -R linuxbrew: /home/linuxbrew/.linuxbrew
RUN git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew

## Brew Packages
USER linuxbrew
RUN env PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" brew update

# Install all package managers first
RUN env PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" brew install \
  node \
  pnpm \
  goenv \
  fish

USER root

RUN env PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" goenv install 1.24.1 && env PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" goenv global 1.24.1
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/root/.goenv/bin:/root/.goenv/shims:${PATH}"
RUN GOPATH_DIR=$(go env GOPATH) && echo "export PATH=\$PATH:${GOPATH_DIR}/bin" >> /root/.bashrc
RUN /home/linuxbrew/.linuxbrew/bin/fish -c "set -Ux PATH \$PATH (go env GOPATH)/bin"
RUN echo "set -gx PATH \$PATH (go env GOPATH)/bin" >> /root/.config/fish/config.fish

RUN  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

SHELL ["/home/linuxbrew/.linuxbrew/bin/fish", "-c"]

ENV SHELL=fish

RUN pnpm setup

RUN pnpm install -g @google/gemini-cli
RUN pnpm install -g @anthropic-ai/claude-code
## Go packages
RUN go install github.com/a-h/templ/cmd/templ@latest

## Rust packages

## Brew Packages
USER linuxbrew
RUN env PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" brew install \
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
  docker \
  just

USER root

WORKDIR /root

COPY config/ /root/.config/

RUN lla theme pull

# Note: GOPATH/bin is added to PATH in config/fish/config.fish (mounted from host)

CMD ["fish"]
