cd "$(dirname "$(readlink -f "$0")")"

# Check if container is already running
CONTAINER_NAME="development-environment"
IMAGE_NAME="ghcr.io/alexjbarnes/development-environment:latest"

# Check if a container with our image is already running
RUNNING_CONTAINER=$(docker ps --filter "ancestor=$IMAGE_NAME" --format "{{.ID}}" | head -n1)

if [ -n "$RUNNING_CONTAINER" ]; then
  echo "Container already running (ID: $RUNNING_CONTAINER). Executing into it..."
  docker exec -it "$RUNNING_CONTAINER" fish
else
  echo "Starting new container..."
  docker run \
    --name "$CONTAINER_NAME-$$" \
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
    -v ~/repos/development-environment/config:/home/dev/.config \
    -v ~/.gitconfig:/home/dev/.gitconfig \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.claude/:/home/dev/.claude/ \
    -v ~/.claude.json:/home/dev/.claude.json \
    -it "$IMAGE_NAME" fish
fi
