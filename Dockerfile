FROM debian:latest

## Apt packages
RUN apt-get update && apt-get install -y curl

## GO packages

## Rust packages

# Set working directory
WORKDIR /app

# Command to run when container starts
CMD ["bash"]
