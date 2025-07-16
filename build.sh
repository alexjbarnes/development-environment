cd ~/repos/development-environment
docker build -t  ghcr.io/alexjbarnes/development-environment:latest . --build-arg GITHUB_TOKEN=$GITHUB_TOKEN
