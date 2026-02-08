#!/bin/bash

# Check for --remove flag
if [[ "$1" == "--remove" ]]; then
  echo "Removing Envoy Gateway..."
  kubectl delete -f https://github.com/envoyproxy/gateway/releases/download/latest/install.yaml
  
  echo "Removing Gateway API CRDs..."
  kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
  
  echo "✓ Envoy Gateway removed successfully!"
  exit 0
fi

# Remove any existing installation first
echo "Removing any existing Envoy Gateway installation..."
kubectl delete -f https://github.com/envoyproxy/gateway/releases/download/latest/install.yaml --ignore-not-found=true 2>/dev/null || true

echo "Removing any existing Gateway API CRDs..."
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml --ignore-not-found=true 2>/dev/null || true

echo "✓ Cleanup complete"
echo ""

# Install Envoy Gateway and prerequisites
echo "Installing Gateway API CRDs..."

# Install Gateway API CRDs (using server-side apply to avoid annotation size limits)
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

echo "✓ Gateway API CRDs installed"

echo "Installing Envoy Gateway (latest)..."

# Install Envoy Gateway (using server-side apply to avoid annotation size limits)
kubectl apply --server-side -f https://github.com/envoyproxy/gateway/releases/download/latest/install.yaml

echo "Waiting for Envoy Gateway to be ready..."
kubectl wait --timeout=5m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available

echo "✓ Envoy Gateway installed successfully!"

# Show installation status
echo ""
echo "Installation Status:"
kubectl get pods -n envoy-gateway-system
kubectl get gatewayclass
