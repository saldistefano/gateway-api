# Simple Web

A SvelteKit web application for learning Envoy Gateway and Kubernetes application networking.

## Overview

This is an interactive learning platform that provides:
- **Data Exploration**: Browse products, users, posts, and quotes from DummyJSON API
- **Envoy Gateway Education**: Learn about Gateway API concepts, HTTPRoutes, and policies
- **Configuration Viewer**: See kubectl commands and configuration examples
- **Feature Testing**: Explore advanced Envoy Gateway features (rate limiting, canary deployments, etc.)

## Structure

```
simple-web/
├── app/              # SvelteKit application source
│   ├── src/
│   │   ├── routes/   # SvelteKit pages
│   │   └── lib/      # Shared libraries (API client)
│   ├── static/       # Static assets
│   └── package.json
├── docker/           # Docker build files
│   ├── Dockerfile    # Multi-stage distroless build
│   └── build.sh      # Build script
├── k8s/              # Kubernetes manifests
│   └── helm/         # Helm chart
└── README.md
```

## Building the Container

The container is built from the SvelteKit app in the `app/` directory.

```bash
cd docker
./build.sh
```

The build creates a hardened container using:
- Multi-stage build with Debian bookworm slim (builder)
- Google's distroless Node.js 20 runtime (final)
- Non-root user (UID 65532)
- Minimal attack surface (no shell, no package manager)
- SvelteKit adapter-node for production Node.js server

## Deploying with Helm

```bash
# Load the image into kind cluster
kind load docker-image simple-web:latest --name envoy-gateway

# Deploy using Helm
helm install simple-web k8s/helm --namespace simple-web --create-namespace

# Verify deployment
kubectl get pods -n simple-web
kubectl get httproute -n simple-web
```

## Accessing the Application

The web application is exposed via HTTPRoute using the hostname `web.local`.

### Via Port Forward (Development)

```bash
# Port forward to the service
kubectl port-forward -n simple-web svc/simple-web 8080:80

# Open in browser
open http://localhost:8080
```

### Via Gateway (Production-like)

To access via the Envoy Gateway:
1. Get the Envoy Gateway service endpoint
2. Add `web.local` to your `/etc/hosts` or use curl with Host header

```bash
# Get the gateway address
kubectl get gateway -n envoy-testing eg

# Access with Host header
curl -H "Host: web.local" http://<gateway-address>/
```

## Features

### Home Page
- Introduction to Envoy Gateway
- Key concepts explanation
- Quick links to explore features

### Data Pages
- **Products**: Browse and search products from DummyJSON
- **Users**: View user profiles
- **Posts**: Read blog posts
- **Quotes**: Inspirational quotes

### Learning Pages
- **Gateway Config**: View Envoy Gateway configuration with kubectl commands
- **Features**: Explore advanced capabilities (rate limiting, canary deployments, etc.)

### Advanced Features (TODO)
The following features are placeholders for future implementation:
- Rate Limiting configuration UI
- Canary deployment setup
- Authentication policies
- CORS configuration
- Header modification
- Circuit breaking

## API Integration

The web app calls the `simple-api` service via Envoy Gateway at `api.local`, demonstrating real gateway routing and providing an end-to-end example of microservices communication through Envoy Gateway.

## Configuration

Environment variables (configured in Helm values):
- `NODE_ENV=production` - Node environment
- `PORT=3000` - Container port
- `ORIGIN=http://web.local` - SvelteKit origin for CSRF protection

## Security Features

- Runs as non-root user (UID 65532)
- No privileged escalation
- All capabilities dropped
- Distroless base image (no shell access)
- Resource limits enforced
- Health probes configured

## Development

To run locally for development:

```bash
cd app
npm install
npm run dev
```

The app will be available at `http://localhost:3000`.

Note: API calls to `api.local` will fail in local development unless you configure local DNS or use a proxy.

## Upgrading

```bash
# Rebuild and load new image
cd docker && ./build.sh
kind load docker-image simple-web:latest --name envoy-gateway

# Upgrade Helm release
helm upgrade simple-web k8s/helm --namespace simple-web
```

## Uninstalling

```bash
helm uninstall simple-web --namespace simple-web
kubectl delete namespace simple-web
```

## Notes

- Gateway `eg` must exist in `envoy-testing` namespace (configured in Helm values)
- Image uses `pullPolicy: Never` for kind cluster (local images only)
- The app demonstrates Envoy Gateway routing by calling `api.local` service
- This is a learning tool - not intended for production use without additional security hardening
