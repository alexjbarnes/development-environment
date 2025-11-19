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
    echo "Container is running. Executing into it..."
    docker exec -it -w /home/dev/repos "$CONTAINER_NAME" fish
  else
    echo "Container exists but is stopped. Starting it..."
    docker start "$CONTAINER_NAME"
    echo "Container started. Executing into it..."
    docker exec -it -w /home/dev/repos "$CONTAINER_NAME" fish
  fi
else
  echo "Container doesn't exist. Starting it..."
  ./start-container.sh
  echo "Executing into container..."
  docker exec -it -w /home/dev/repos "$CONTAINER_NAME" fish
fi
