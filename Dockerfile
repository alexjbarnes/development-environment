FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl git

## Create non root user
RUN useradd -m -s /bin/bash nonroot

## Install Homebrew 
USER nonroot
WORKDIR /home/brew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN brew list
## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
