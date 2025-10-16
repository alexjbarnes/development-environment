#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

# Fixed container name for persistence
CONTAINER_NAME="development-environment"

# Check if container exists
CONTAINER_EXISTS=$(docker ps -a --filter "name=^${CONTAINER_NAME}$" --format "{{.Names}}" | head -n1)

if [ -n "$CONTAINER_EXISTS" ]; then
  echo "Stopping and removing container..."
  docker stop "$CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
  echo "Container stopped and removed successfully."
else
  echo "Container does not exist."
fi

# Show container status
echo "Container status:"
docker ps -a --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"