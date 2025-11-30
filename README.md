# Development Environment

Dockerized development environment using Debian Bookworm Slim with mise for tool version management.

## Quick Start

```bash
# Start or attach to the persistent container
./run-local.sh

# Stop and remove the container
./stop-container.sh
```

## What's Included

**Languages** (via mise):
- Go 1.25.3
- Node.js 24.10.0
- Python (latest)
- Rust (latest)

**Tools**:
- Neovim with LazyVim
- ripgrep, fd, btop, television
- Docker CLI, kubectl, k9s
- Claude Code, Gemini CLI, OpenCode
- just, opentofu, atuin

**Go packages**: templ, gofumpt, golangci-lint, air, govulncheck, mockgen, staticcheck

**Rust packages**: lla, tlrc, somo, mergiraf

## Container Details

- User: `dev` (uid 1000) with passwordless sudo
- Shell: Fish with starship prompt
- Working directory: `/home/dev/repos`

Shell aliases:
- `ls` -> `lla`
- `grep` -> `rg`
- `vim` -> `nvim`

## Building

```bash
# Build locally
./build.sh

# Clean up Docker resources
./cleanup.sh
```

The image is automatically built and pushed to `ghcr.io/alexjbarnes/development-environment:latest` on every push to main.

## Adding Tools

1. **mise-managed tools**: Add to `mise.toml` and the `mise use -g` command in Dockerfile
2. **Go packages**: Add `go install` command in Dockerfile
3. **Rust packages**: Add `cargo install` command in Dockerfile
4. **System packages**: Add to the `apt-get install` line in Dockerfile

## Volume Mounts

Key directories persisted from host:
- `~/repos` - Source code
- `~/.ssh` - SSH keys
- `~/.local/share/atuin` - Shell history
- `~/.local/share/fish` - Fish shell data
- `~/.local/share/nvim` - Neovim state
- `~/.claude` - Claude Code config

## Tool Reference

### Languages and Runtimes
| Tool | Description |
|------|-------------|
| go | Go programming language |
| node | Node.js JavaScript runtime |
| python | Python interpreter |
| rust | Rust programming language and cargo |

### Editors
| Tool | Description |
|------|-------------|
| neovim | Hyperextensible text editor (aliased to `vim`) |

### AI Assistants
| Tool | Description |
|------|-------------|
| claude | Claude Code CLI from Anthropic |
| gemini-cli | Google Gemini CLI |
| opencode | AI coding assistant |
| vibe-kanban | Kanban board to manage AI coding agents |

### Container and Infrastructure
| Tool | Description |
|------|-------------|
| docker-cli | Docker command line interface |
| kubectl | Kubernetes command line tool |
| k9s | Terminal UI for Kubernetes |
| opentofu | Terraform-compatible infrastructure as code |

### Shell and Terminal
| Tool | Description |
|------|-------------|
| fish | User-friendly shell (default) |
| starship | Cross-shell prompt |
| atuin | Shell history search and sync |
| television | Fuzzy finder for terminal |

### Search and File Tools
| Tool | Description |
|------|-------------|
| ripgrep | Fast regex search tool (aliased to `grep`) |
| fd | Fast file finder |
| lla | Modern ls replacement with git integration (aliased to `ls`) |

### Development Utilities
| Tool | Description |
|------|-------------|
| just | Command runner for project tasks |
| btop | Resource monitor |
| pnpm | Fast Node.js package manager |
| lazygit | Terminal UI for git |
| lazydocker | Terminal UI for Docker |

### Go Packages
| Tool | Description |
|------|-------------|
| templ | Type-safe HTML templating for Go |
| gofumpt | Stricter gofmt |
| golangci-lint | Go linter aggregator |
| air | Live reload for Go apps |
| govulncheck | Go vulnerability checker |
| mockgen | Mock generator for Go interfaces |
| staticcheck | Static analysis for Go |

### Rust Packages
| Tool | Description |
|------|-------------|
| tlrc | Simplified man pages (tldr client) |
| somo | Human-friendly netstat alternative for socket and port monitoring |
| mergiraf | Semantic merge driver for git |
