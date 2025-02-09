FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl git

## Install Homebrew 
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
