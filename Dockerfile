FROM debian:latest

ENV USER nix
ENV NIX_PATH /nix/var/nix/profiles/per-user/root/channels

RUN apt-get update && apt-get install -y curl xz-utils sudo

RUN adduser --disabled-password --gecos '' nix
USER nix
WORKDIR /home/nix

RUN touch .bash_profile && \
    curl https://nixos.org/nix/install | sh

# . /home/nix/.nix-profile/etc/profile.d/nix.sh && \
   # nix-env -iA nixpkgs.hello

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
