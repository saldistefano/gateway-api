#!/bin/bash

# Create kind cluster for Envoy Gateway
echo "Creating kind cluster..."

kind create cluster --name envoy-gateway

echo "✓ Kind cluster created successfully!"
echo "Cluster name: envoy-gateway"

# Verify cluster is running
kubectl cluster-info --context kind-envoy-gateway
