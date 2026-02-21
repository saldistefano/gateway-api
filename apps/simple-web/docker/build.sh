#!/bin/bash
set -e

# Build the simple-web Docker image from the SvelteKit app source
APP_PATH="../app"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Building simple-web container from: $APP_PATH"

cd "$SCRIPT_DIR"

docker build -t simple-web:latest \
    -f Dockerfile \
    "$APP_PATH"

echo "Image built successfully!"
echo "To load into kind cluster: kind load docker-image simple-web:latest --name envoy-gateway"
