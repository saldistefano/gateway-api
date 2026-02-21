# Simple API

A containerized deployment of [DummyJSON](https://dummyjson.com) API for local development using Envoy Gateway.

## Overview

This folder contains the Kubernetes manifests and Helm chart to deploy a hardened DummyJSON API instance to a local kind cluster with Envoy Gateway.

## Deployment Summary

This deployment was created to provide a local API server for development using the DummyJSON project as the data source. Key achievements:

**Container Image**
- Built from original DummyJSON source at `/Users/sald/code/DummyJSON/`
- Multi-stage build using Debian bookworm slim + Google's distroless Node.js 20 runtime
- Hardened security: non-root user (UID 65532), no shell, minimal attack surface
- Fixed sharp library compatibility issue with `npm rebuild sharp` for ARM64 architecture

**Kubernetes Deployment**
- Deployed to `simple-api` namespace via Helm chart
- HTTPRoute configured with hostname `api.local` pointing to gateway `eg` in `envoy-testing` namespace
- Security policies enforced: no privilege escalation, all capabilities dropped
- Resource limits: 256Mi memory limit, 200m CPU limit
- Health probes configured for liveness and readiness at `/test` endpoint

**Verified Working**
- Pod running successfully and stable
- Health check endpoint: `GET /test` returns `{"status":"ok","method":"GET"}`
- Products API tested and returning data correctly
- MongoDB connection errors are expected (MongoDB not deployed, but API works without it)

**Project Structure**
- Kept DummyJSON source in original location to avoid duplication
- This folder only contains deployment artifacts (Docker build files, K8s manifests, Helm chart)
- Clean separation between source code and deployment configuration

## Structure

```
simple-api/
├── docker/           # Docker build files
│   ├── Dockerfile    # Multi-stage distroless build
│   └── build.sh      # Build script
├── k8s/              # Kubernetes manifests
│   ├── helm/         # Helm chart
│   ├── deployment.yaml
│   ├── httproute.yaml
│   ├── namespace.yaml
│   └── service.yaml
└── README.md
```

## Building the Container

The container is built from the DummyJSON source located at `/Users/sald/code/DummyJSON/`.

```bash
cd docker
./build.sh
```

The build creates a hardened container using:
- Multi-stage build with Debian bookworm slim (builder stage)
- Google's distroless Node.js 20 runtime (final runtime)
- Non-root user (UID 65532)
- Minimal attack surface (no shell, no package manager)
- Sharp library rebuilt for ARM64 compatibility

**Note:** The Dockerfile references the original DummyJSON source location to avoid duplicating all source files in this directory.

## Deploying with Helm

```bash
# Load the image into kind cluster
kind load docker-image simple-api:latest --name envoy-gateway

# Deploy using Helm
helm install simple-api k8s/helm --namespace simple-api --create-namespace

# Verify deployment
kubectl get pods -n simple-api
kubectl get httproute -n simple-api
```

## Accessing the API

The API is exposed via HTTPRoute using the hostname `api.local` through the `eg` gateway in the `envoy-testing` namespace.

### Quick Test via Port Forward

```bash
# Port forward to the service
kubectl port-forward -n simple-api svc/simple-api 8080:80

# Test the health endpoint
curl http://localhost:8080/test

# Test the products API
curl http://localhost:8080/products | jq '.products[0:2]'
```

### Access via Gateway (Production-like)

To access via the Envoy Gateway:
1. Get the Envoy Gateway service endpoint
2. Add `api.local` to your `/etc/hosts` or use curl with Host header

```bash
# Get the gateway address
kubectl get gateway -n envoy-testing eg

# Test the API (example)
curl -H "Host: api.local" http://<gateway-address>/products
```

## Available Endpoints

- `GET /products` - List all products
- `GET /users` - List all users
- `GET /posts` - List all posts
- `GET /quotes` - List all quotes
- `GET /test` - Health check endpoint

For full API documentation, visit: https://dummyjson.com/docs

## Configuration

Environment variables (configured in Helm values):
- `NODE_ENV=production` - Node environment
- `PORT=3000` - Container port
- `NUM_WORKERS=1` - Number of worker processes
- `JWT_SECRET` - JWT signing secret (demo value)
- `MONGODB_URI` - MongoDB connection (optional, defaults to localhost)

## Security Features

- Runs as non-root user (UID 65532)
- No privileged escalation
- All capabilities dropped
- Distroless base image (no shell access)
- Resource limits enforced
- Health probes configured

## Upgrading

```bash
# Rebuild and load new image
cd docker && ./build.sh
kind load docker-image simple-api:latest --name envoy-gateway

# Upgrade Helm release
helm upgrade simple-api k8s/helm --namespace simple-api
```

## Uninstalling

```bash
helm uninstall simple-api --namespace simple-api
kubectl delete namespace simple-api
```

## Troubleshooting

**Pod CrashLoopBackOff**
- Check logs: `kubectl logs -n simple-api <pod-name>`
- Common issue: Sharp library not rebuilt - ensure `npm rebuild sharp` is in Dockerfile
- Verify image was loaded into kind: `docker exec -it envoy-gateway-control-plane crictl images | grep simple-api`

**API Not Accessible**
- Verify pod is running: `kubectl get pods -n simple-api`
- Check HTTPRoute: `kubectl get httproute -n simple-api`
- Verify gateway exists: `kubectl get gateway -n envoy-testing eg`
- Test directly via port-forward first to isolate gateway issues

**MongoDB Connection Errors**
- These are expected and can be ignored - MongoDB is not deployed
- The API works without MongoDB for read-only endpoints (products, users, etc.)
- Only authentication endpoints require MongoDB

## Notes

- Gateway `eg` must exist in `envoy-testing` namespace (configured in Helm values)
- Image uses `pullPolicy: Never` for kind cluster (local images only)
- Environment variables for JWT and MongoDB are set to demo values (not for production use)
