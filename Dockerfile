FROM debian:bookworm-slim
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=$GITHUB_TOKEN

# Set timezone first
RUN ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo Europe/London > /etc/timezone

# Install system packages as root (install sudo first)
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get install -y --no-install-recommends gnupg curl git build-essential locales ca-certificates openssh-client net-tools fish unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create dev user and give sudo access (for system-level changes only)
RUN useradd -m -u 1000 -s /usr/bin/fish dev && \
    usermod -aG sudo dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev && \
    addgroup --gid 1001 devcontainer && \
    adduser dev devcontainer

# Switch to dev user for ALL development tool installations
USER dev
WORKDIR /home/dev

# Install Mise for dev user (not system-wide)
ENV MISE_DATA_DIR="/home/dev/.local/share/mise"
ENV MISE_CONFIG_DIR="/home/dev/.config/mise"
ENV MISE_CACHE_DIR="/home/dev/.cache/mise"
ENV MISE_INSTALL_PATH="/home/dev/.local/bin/mise"

RUN curl https://mise.run | sh

# Setup PATH for the session
ENV PATH="/home/dev/.local/share/mise/shims:/home/dev/.local/bin:/home/dev/.local/share/pnpm:$PATH"

# Create fish config directory and setup environment
RUN mkdir -p /home/dev/.config/fish && \
    echo 'set -gx PATH "/home/dev/.local/share/mise/shims" "/home/dev/.local/bin" "/home/dev/.local/share/pnpm" "/home/dev/.cargo/bin" $PATH' > /home/dev/.config/fish/config.fish && \
    echo 'set -gx MISE_DATA_DIR "/home/dev/.local/share/mise"' >> /home/dev/.config/fish/config.fish && \
    echo 'set -gx MISE_CONFIG_DIR "/home/dev/.config/mise"' >> /home/dev/.config/fish/config.fish && \
    echo 'set -gx MISE_CACHE_DIR "/home/dev/.cache/mise"' >> /home/dev/.config/fish/config.fish

# Install development tools via mise
COPY --chown=dev:dev mise.toml .
RUN /home/dev/.local/bin/mise trust mise.toml && /home/dev/.local/bin/mise install

# Install Go packages using mise exec to ensure proper environment
RUN /home/dev/.local/bin/mise exec -- go install github.com/a-h/templ/cmd/templ@latest && \
    /home/dev/.local/bin/mise exec -- go install mvdan.cc/gofumpt@latest && \
    /home/dev/.local/bin/mise exec -- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    /home/dev/.local/bin/mise exec -- go install github.com/air-verse/air@latest && \
    /home/dev/.local/bin/mise exec -- go install golang.org/x/vuln/cmd/govulncheck@latest && \
    /home/dev/.local/bin/mise exec -- go install go.uber.org/mock/mockgen@latest && \
    /home/dev/.local/bin/mise exec -- go install honnef.co/go/tools/cmd/staticcheck@latest

# Install Rust packages as dev user
RUN cargo install lla && cargo install tlrc@1.11.0

# Install ai tools
ENV SHELL=/bin/bash
RUN /home/dev/.local/bin/mise exec -- pnpm setup && \
    PNPM_HOME="/home/dev/.local/share/pnpm" PATH="/home/dev/.local/share/pnpm:$PATH" /home/dev/.local/bin/mise exec -- pnpm install -g vibe-kanban

# Initialize fish to prevent universal variables permission issues
RUN fish -c "set -U fish_greeting ''" || true

# Set shell and ensure proper environment

CMD ["fish"]
