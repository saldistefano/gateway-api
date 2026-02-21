#!/bin/bash
set -e

# Build the simple-api Docker image from the DummyJSON source
DUMMYJSON_PATH="/Users/sald/code/DummyJSON"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Building simple-api container from: $DUMMYJSON_PATH"

docker build -t simple-api:latest \
    -f "$SCRIPT_DIR/Dockerfile" \
    "$DUMMYJSON_PATH"

echo "Image built successfully!"
echo "To load into kind cluster: kind load docker-image simple-api:latest --name envoy-gateway"
