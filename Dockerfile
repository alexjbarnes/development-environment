FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl git

## Create a nonroot user "brew" (with home directory) and allow passwordless sudo if needed.
RUN useradd -m brew && echo "brew ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Switch to the nonroot user
USER brew
ENV HOME /home/brew

## Install Homebrew noninteractively.
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew --version

## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
