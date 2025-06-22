cd "$(dirname "$(readlink -f "$0")")"

docker run \
  --env-file .env \
  --privileged \
  -v /proc:/proc \
  -v /sys:/sys \
  -v ~/.ssh/:/root/.ssh/ \
  -v ~/repos:/root/repos \
  -v /root/.local/share/:/root/.local/share/ \
  -v ~/repos/development-environment/config:/root/.config \
  -v ~/.gitconfig:/root/.gitconfig \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -it ghcr.io/alexjbarnes/development-environment:latest fish
