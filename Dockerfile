FROM debian:latest

# Update package lists and install basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    sudo \
    xz-utils \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create the nixbld group and users
RUN groupadd nixbld && \
    for i in $(seq 1 10); do \
        useradd -m -s /bin/false -g nixbld nixbld$i; \
    done

# Download and install Nix in single-user mode
RUN curl -L https://nixos.org/nix/install -o install-nix.sh && \
    sh install-nix.sh --no-daemon && \
    rm install-nix.sh


# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
