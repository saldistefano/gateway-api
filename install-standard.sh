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

# Install Envoy Gateway and prerequisites
echo "Installing Gateway API CRDs..."

# Install Gateway API CRDs (using server-side apply to avoid annotation size limits)
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

echo "✓ Gateway API CRDs installed"

echo "Installing Envoy Gateway..."

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
