#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

# Fixed container name for persistence
CONTAINER_NAME="development-environment"
IMAGE_NAME="ghcr.io/alexjbarnes/development-environment:latest"

# Check if container exists (running or stopped)
CONTAINER_EXISTS=$(docker ps -a --filter "name=^${CONTAINER_NAME}$" --format "{{.Names}}" | head -n1)

if [ -n "$CONTAINER_EXISTS" ]; then
  # Container exists, check if it's running
  CONTAINER_RUNNING=$(docker ps --filter "name=^${CONTAINER_NAME}$" --format "{{.Names}}" | head -n1)
  
  if [ -n "$CONTAINER_RUNNING" ]; then
    echo "Container is already running."
  else
    echo "Container exists but is stopped. Starting it..."
    docker start "$CONTAINER_NAME"
    echo "Container started successfully."
  fi
else
  echo "Creating new persistent container..."
  docker run \
    --name "$CONTAINER_NAME" \
    --restart always \
    --env-file .env \
    --network host \
    --privileged \
    --pid host \
    --group-add 1001 \
    --group-add 102 \
    -v /proc:/proc \
    -v /sys:/sys \
    -v ~/.ssh/:/home/dev/.ssh/ \
    -v ~/repos:/home/dev/repos \
    -v ~/.local/share/fish/:/home/dev/.local/share/fish/ \
    -v ~/.local/share/nvim/:/home/dev/.local/share/nvim/ \
    -v ~/repos/development-environment/config/git:/home/dev/.config/git \
    -v ~/repos/development-environment/config/lla:/home/dev/.config/lla \
    -v ~/repos/development-environment/config/nvim:/home/dev/.config/nvim \
    -v ~/.gitconfig:/home/dev/.gitconfig \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.claude/:/home/dev/.claude/ \
    -v ~/.claude.json:/home/dev/.claude.json \
    -v ~/.local/share/vibe-kanban:/home/dev/.local/share/vibe-kanban \
    -v ~/repos/development-environment/config/claude-code-ui/auth.db:/home/dev/claudecodeui/server/database/auth.db \
    -d "$IMAGE_NAME" sleep infinity
  
  echo "Container created and running in background."
  
# Start AI tools
  echo "Starting AI tools..."
  docker exec "$CONTAINER_NAME" bash -c "cd /home/dev/repos/development-environment && ./start-ai-tools.sh"
fi

# Show container status
echo "Container status:"
docker ps --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
