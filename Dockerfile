FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl git

## Create a nonroot user "brew" (with home directory) and allow passwordless sudo if needed.
RUN useradd -m brew && echo "brew ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Switch to the nonroot user
USER brew
ENV HOME /home/brew

# Set Homebrew environment variables to install under the nonroot user's home.
ENV HOMEBREW_PREFIX="$HOME/.linuxbrew" \
    HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew" \
    HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar" \
    HOMEBREW_CACHE="$HOME/.cache/Homebrew"

# Create Homebrew prefix directory and install Homebrew in noninteractive mode.
RUN mkdir -p "$HOMEBREW_PREFIX" && \
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew --version

## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
