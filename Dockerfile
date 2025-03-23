FROM debian:latest

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
    goenv \
    ripgrep \
    television \
    jesseduffield/lazygit/lazygit \
    btop \
    knqyf263/pet/pet \
    opentofu \
    lla

USER root
## Install Go
RUN goenv install 1.24.1 && goenv global 1.24.1

## Go packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
