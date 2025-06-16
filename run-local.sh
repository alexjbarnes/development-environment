cd "$(dirname "$(readlink -f "$0")")"

docker run --env-file .env --privileged -v /proc:/proc -v /sys:/sys -v ~/repos:/root/repos -v /root/.local/share/fish/fish_history:/root/.local/share/fish/fish_history -v ~/repos/development-environment/config:/root/.config -v ~/repos/development-environment/nvim:/root/.local/share/nvim -v /var/run/docker.sock:/var/run/docker.sock -it ghcr.io/alexjbarnes/development-environment:latest fish
