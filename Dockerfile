FROM debian:latest

# Update package lists and install basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    sudo \
    xz-utils \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*
   # sh <(curl -L https://nixos.org/nix/install) --daemon

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
