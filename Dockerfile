FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl git build-essential

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
RUN brew install goenv

## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
