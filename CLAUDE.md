# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dockerized development environment that provides a fully-featured, portable development container with pre-installed tools and configurations. It uses Debian Bookworm Slim as the base and sets up a comprehensive development environment with modern tooling.

## Common Commands

### Building and Running the Environment

```bash
# Build the Docker image
./build.sh

# Run the container with full volume mounts (recommended for development)
./run-local.sh

# Simple run without extensive mounts
./run.sh
```

### Inside the Container

The container uses Fish shell with these key aliases:
- `ls` → `lla` (modern ls alternative with themes)
- `grep` → `rg` (ripgrep - faster grep)
- `vim` → `nvim` (Neovim with LazyVim configuration)
- `ai` → Cody AI chat assistant

### Development Tools Available

**Go Development** (v1.24.4 via goenv):
- `templ` - HTML templating
- `gofumpt` - Go formatter
- `golangci-lint` - Go linter
- `air` - Live reload for Go applications
- `govulncheck` - Vulnerability checker

**Node.js Development**:
- `pnpm` - Fast package manager
- `@anthropic-ai/claude-code` - Claude Code CLI
- `@google/gemini-cli` - Gemini AI CLI

**Other Tools**:
- `just` - Command runner for project tasks
- `lazygit` - Git TUI interface
- `docker` - Container operations (via socket mount)
- `opentofu` - Terraform fork
- `television` - Terminal file browser

## Architecture and Structure

### Container Architecture
- **Base Image**: Debian Bookworm Slim with Homebrew package manager
- **Default Shell**: Fish shell with custom configuration
- **User**: Runs as root with pre-configured environment
- **Working Directory**: `/root`

### Volume Mounts (from run-local.sh)
- `~/.ssh/` → `/root/.ssh/` - SSH keys for Git operations
- `~/repos` → `/root/repos` - Source code repositories
- `~/repos/development-environment/config` → `/root/.config` - Tool configurations
- `/var/run/docker.sock` → `/var/run/docker.sock` - Docker socket for container operations
- `~/.claude/` and `~/.claude.json` - Claude Code configuration

### Configuration Structure
```
config/
├── fish/          # Fish shell functions, aliases, and theme
├── nvim/          # Neovim LazyVim configuration
├── git/           # Global gitignore rules
├── btop/          # System monitor themes
├── television/    # Terminal browser config
├── lla/           # File listing themes
└── cody/          # Sourcegraph AI assistant config
```

### Key Development Patterns
1. **Multi-language Support**: The environment supports Go, Node.js, and Rust development
2. **Persistent Configuration**: Configurations are mounted from the host to preserve settings across container restarts
3. **AI-Assisted Development**: Both Claude Code and Gemini CLI are pre-installed
4. **Modern CLI Tools**: Traditional Unix tools are replaced with modern alternatives (ripgrep, fd, lla)

### Notes for Development
- Go binaries are installed to `$(go env GOPATH)/bin` which is added to PATH
- The container runs with `--network host` and `--privileged` for system monitoring tools
- All package installations should be added to the Dockerfile for reproducibility
- Fish shell configuration can be extended via files in `config/fish/`