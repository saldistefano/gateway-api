# Gateway Management Best Practices

**Model**: Single Shared Default Gateway

## Overview

This document outlines best practices for managing a single shared Gateway across all applications in the cluster. This model prioritizes simplicity while maintaining security and performance.

## Architecture

### Gateway Ownership Model

- **Platform Team**: Owns and manages the default Gateway resource
- **Application Teams**: Create HTTPRoutes that reference the shared Gateway
- **Namespace**: `ics-envoy-gateway` (dedicated namespace for gateway resources)

```
ics-envoy-gateway/
  ├── gateway.yaml              # Default shared gateway
  ├── security-policy.yaml      # Security configurations
  ├── client-traffic-policy.yaml # Performance & traffic settings
  └── rbac.yaml                 # Access control policies

app-team-a/
  ├── httproute.yaml           # References default gateway
  └── backend-services.yaml

app-team-b/                  
  ├── httproute.yaml           # References default gateway
  └── backend-services.yaml
```

## RBAC Configuration

### Platform Team Permissions

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: gateway-platform-admin
rules:
- apiGroups: ["gateway.networking.k8s.io"]
  resources: ["gatewayclasses", "gateways"]
  verbs: ["create", "update", "delete", "get", "list", "watch"]
- apiGroups: ["gateway.envoyproxy.io"]
  resources: ["securitypolicies", "clienttrafficpolicies", "backendtrafficpolicies"]
  verbs: ["create", "update", "delete", "get", "list", "watch"]
```

### Application Team Permissions

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-team-gateway-user
  namespace: <team-namespace>
rules:
- apiGroups: ["gateway.networking.k8s.io"]
  resources: ["httproutes", "grpcroutes"]
  verbs: ["create", "update", "delete", "get", "list", "watch"]
- apiGroups: ["gateway.networking.k8s.io"]
  resources: ["gateways"]
  verbs: ["get", "list"]  # Read-only access to discover gateways
# No permission to create/modify Gateways
```

## Kyverno Policy Enforcement

Kyverno policies enforce governance and automate gateway provisioning while preventing unauthorized gateway creation.

### Restriction Policies

These policies prevent LOB teams from creating unapproved gateways and enforce compliance requirements.

**Policy Files**: [policies/restriction/](policies/restriction/)

| Policy | Severity | Description | File |
|--------|----------|-------------|------|
| Restrict Gateway Creation | High | Prevents unauthorized Gateway creation outside approved namespaces | [restrict-gateway-creation.yaml](policies/restriction/restrict-gateway-creation.yaml) |
| Enforce Gateway Class | Medium | Ensures all Gateways use the 'eg' GatewayClass | [enforce-gateway-class.yaml](policies/restriction/enforce-gateway-class.yaml) |
| Require Gateway TLS | High | Requires TLS configuration on all HTTPS listeners | [require-gateway-tls.yaml](policies/restriction/require-gateway-tls.yaml) |
| Protect Gateway Deletion | Medium | Requires approval annotation before Gateway deletion | [protect-gateway-deletion.yaml](policies/restriction/protect-gateway-deletion.yaml) |
| Gateway Resource Limits | Medium | Limits Gateway to maximum 4 listeners | [gateway-resource-limits.yaml](policies/restriction/gateway-resource-limits.yaml) |
| Enforce Same-Namespace References | High | Ensures HTTPRoutes/GRPCRoutes only reference Gateways in same namespace | [enforce-same-namespace-gateway-reference.yaml](policies/restriction/enforce-same-namespace-gateway-reference.yaml) |

**Installation**:
```bash
# Apply all restriction policies
kubectl apply -f docs/policies/restriction/

# Apply individual policy
kubectl apply -f docs/policies/restriction/enforce-gateway-class.yaml
```

### Administrative Policies (Auto-Generation)

These policies automatically create default gateways and supporting resources for LOB application namespaces.

**Policy Files**: [policies/administrative/](policies/administrative/)

**Trigger**: All namespaces **except** those labeled with `system: "true"` (opt-out model)

**System namespaces to exclude**: Label these with `system: "true"`
- `kube-system`, `kube-public`, `kube-node-lease`, `default`
- `ics-envoy-gateway`, `envoy-gateway-system`, `kyverno`

| Policy | Resources Generated | Description | File |
|--------|---------------------|-------------|------|
| Auto-Generate LOB Gateway | Gateway | Creates default Gateway with HTTP/HTTPS listeners | [generate-lob-gateway.yaml](policies/administrative/generate-lob-gateway.yaml) |
| Auto-Generate Wildcard Cert | Secret (TLS) | Clones wildcard certificate template for namespace | [generate-lob-wildcard-cert.yaml](policies/administrative/generate-lob-wildcard-cert.yaml) |
| Auto-Generate HTTPS Redirect | HTTPRoute | Creates HTTP to HTTPS redirect route | [generate-lob-https-redirect.yaml](policies/administrative/generate-lob-https-redirect.yaml) |
| Auto-Generate Security Policy | SecurityPolicy | Applies TLS 1.3, ciphers, and CORS settings | [generate-lob-security-policy.yaml](policies/administrative/generate-lob-security-policy.yaml) |
| Auto-Generate Traffic Policy | ClientTrafficPolicy | Configures timeouts, limits, and HTTP/2 settings | [generate-lob-traffic-policy.yaml](policies/administrative/generate-lob-traffic-policy.yaml) |

**Generated Resources** (example for namespace `finance`):
- `finance-gateway` - Gateway resource
- `finance-wildcard-tls` - TLS certificate Secret  
- `finance-https-redirect` - HTTPRoute for HTTPS redirect
- `finance-security` - SecurityPolicy
- `finance-traffic` - ClientTrafficPolicy

**Installation**:
```bash
# Apply all administrative policies
kubectl apply -f docs/policies/administrative/

# Apply individual policy
kubectl apply -f docs/policies/administrative/generate-lob-gateway.yaml
```

### Gateway Approval Process

For LOB teams requesting additional gateways beyond the auto-generated default:

1. **Submit Request**
   - Create ticket with justification
   - Include: use case, expected traffic, security requirements
   - Platform team reviews

2. **Approval Criteria**
   - Valid business need
   - Cannot use existing gateway
   - Security requirements documented
   - Resource impact assessed

3. **Provisioning**
   - Platform team labels namespace: `additional-gateway-approved: "true"`
   - Update Kyverno policy to allow specific namespace
   - Gateway created via GitOps
   - Documentation updated

4. **Post-Provisioning**
   - Monitor gateway usage
   - Quarterly review of all gateways
   - Decommission unused gateways

### Kyverno Policy Management

#### Installing Kyverno

```bash
# Add Kyverno Helm repository
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

# Install Kyverno
helm install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --set replicaCount=3 \
  --set admissionController.replicas=3

# Install Kyverno policies
helm install kyverno-policies kyverno/kyverno-policies \
  --namespace kyverno
```

#### Testing Policies

```bash
# Test policy before applying
kubectl kyverno apply policy.yaml --resource test-gateway.yaml

# Dry-run validation
kubectl apply -f gateway.yaml --dry-run=server

# Check policy reports
kubectl get policyreport -A
kubectl get clusterpolicyreport
```

#### Monitoring Policies

```bash
# View policy status
kubectl get clusterpolicy

# Check policy violations
kubectl get polr -A -o wide

# View policy events
kubectl get events -n kyverno --sort-by='.lastTimestamp'
```

## Default Gateway Configuration

### Base Gateway Resource

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: default
  namespace: gateway-infrastructure
spec:
  gatewayClassName: eg
  listeners:
    # HTTPS listener (primary)
    - name: https
      protocol: HTTPS
      port: 443
      hostname: "*.example.com"  # Adjust to your domain
      tls:
        mode: Terminate
        certificateRefs:
          - name: wildcard-tls-cert
            kind: Secret
      allowedRoutes:
        namespaces:
          from: All  # Allow routes from any namespace
    
    # HTTP listener (redirect to HTTPS)
    - name: http
      protocol: HTTP
      port: 80
      hostname: "*.example.com"
      allowedRoutes:
        namespaces:
          from: All
```

## Security Policies

### 1. Security Policy (TLS & Hardening)

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: default-gateway-security
  namespace: gateway-infrastructure
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: default
  
  # TLS Configuration
  tls:
    minVersion: "1.3"  # Enforce TLS 1.3 minimum
    ciphers:
      - TLS_AES_128_GCM_SHA256
      - TLS_AES_256_GCM_SHA384
      - TLS_CHACHA20_POLY1305_SHA256
  
  # CORS (if needed globally)
  cors:
    allowOrigins:
      - "https://*.example.com"
    allowMethods:
      - GET
      - POST
      - PUT
      - PATCH
      - DELETE
      - OPTIONS
    allowHeaders:
      - "*"
    exposeHeaders:
      - X-Request-ID
    maxAge: 24h
    allowCredentials: true
  
  # JWT Authentication (optional - can be per-route instead)
  # jwt:
  #   providers:
  #     - name: auth0
  #       issuer: "https://your-tenant.auth0.com/"
  #       audiences:
  #         - "https://api.example.com"
  #       remoteJWKS:
  #         uri: "https://your-tenant.auth0.com/.well-known/jwks.json"
```

### 2. Client Traffic Policy (Performance & Limits)

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: default-gateway-traffic
  namespace: gateway-infrastructure
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: default
  
  # Connection Limits
  connection:
    bufferLimit: 32KiB
    connectionLimit:
      value: 10000  # Max concurrent connections
      closeDelay: 5s
  
  # Timeouts
  timeout:
    http:
      requestReceivedTimeout: 60s
      idleTimeout: 300s  # 5 minutes
      connectionIdleTimeout: 300s
  
  # HTTP/2 Settings
  http2:
    maxConcurrentStreams: 100
    initialStreamWindowSize: 65536
    initialConnectionWindowSize: 1048576
  
  # Preserve Case (important for legacy apps)
  headers:
    preserveHeaderCase: false  # Set true if needed for legacy compatibility
  
  # Request Size Limits
  http1:
    http10:
      defaultHost: "example.com"
  
  # Enable Proxy Protocol (if behind load balancer)
  # enableProxyProtocol: true
  
  # Client IP Detection (important for rate limiting)
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 1  # Adjust based on your load balancer setup
  
  # Health Check Passive
  healthCheck:
    passive:
      unhealthyConnectionCount: 3
      unhealthyRequestCount: 3
      interval: 3s
```

### 3. HTTP to HTTPS Redirect Policy

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: http-to-https-redirect
  namespace: gateway-infrastructure
spec:
  parentRefs:
    - name: default
      namespace: gateway-infrastructure
      sectionName: http  # HTTP listener
  hostnames:
    - "*.example.com"
  rules:
    - filters:
        - type: RequestRedirect
          requestRedirect:
            scheme: https
            statusCode: 301
```

### 4. Global Rate Limiting (Optional)

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: global-rate-limit
  namespace: gateway-infrastructure
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: default
  
  rateLimit:
    type: Global
    global:
      rules:
        - clientSelectors:
            - headers:
                - name: x-user-id
                  type: Distinct
          limit:
            requests: 1000
            unit: Hour
        
        # IP-based rate limiting
        - clientSelectors:
            - sourceCIDR:
                type: Distinct
          limit:
            requests: 100
            unit: Minute
```

## Performance Recommendations

### 1. Gateway Resource Sizing

```yaml
# EnvoyProxy configuration for the Gateway
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: default-proxy-config
  namespace: gateway-infrastructure
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 3  # High availability
        pod:
          resources:
            requests:
              cpu: "500m"
              memory: "512Mi"
            limits:
              cpu: "2000m"
              memory: "2Gi"
          affinity:
            podAntiAffinity:
              preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 100
                  podAffinityTerm:
                    labelSelector:
                      matchLabels:
                        gateway.envoyproxy.io/owning-gateway-name: default
                    topologyKey: kubernetes.io/hostname
      envoyService:
        type: LoadBalancer
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: "nlb"  # AWS example
          # Add your cloud provider annotations
  
  # Logging
  logging:
    level:
      default: warn  # Reduce noise in production
  
  # Metrics
  telemetry:
    metrics:
      prometheus:
        disable: false
    accessLog:
      settings:
        - format:
            type: JSON
            json:
              timestamp: "%START_TIME%"
              method: "%REQ(:METHOD)%"
              path: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
              protocol: "%PROTOCOL%"
              response_code: "%RESPONSE_CODE%"
              response_flags: "%RESPONSE_FLAGS%"
              bytes_received: "%BYTES_RECEIVED%"
              bytes_sent: "%BYTES_SENT%"
              duration: "%DURATION%"
              upstream_service_time: "%RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)%"
              forwarded_for: "%REQ(X-FORWARDED-FOR)%"
              user_agent: "%REQ(USER-AGENT)%"
              request_id: "%REQ(X-REQUEST-ID)%"
```

### 2. HorizontalPodAutoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: default-gateway-hpa
  namespace: envoy-gateway-system
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: envoy-gateway-infrastructure-default  # Adjust to actual deployment name
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 50
          periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
        - type: Percent
          value: 100
          periodSeconds: 30
        - type: Pods
          value: 2
          periodSeconds: 30
      selectPolicy: Max
```

## Monitoring & Observability

### Key Metrics to Monitor

1. **Gateway Health**
   - Envoy proxy pod status
   - Gateway listener status
   - Certificate expiration

2. **Traffic Metrics**
   - Requests per second
   - Response codes (2xx, 4xx, 5xx)
   - Request latency (p50, p95, p99)
   - Active connections

3. **Resource Usage**
   - CPU utilization
   - Memory utilization
   - Network throughput

### Prometheus ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: envoy-gateway-metrics
  namespace: envoy-gateway-system
spec:
  selector:
    matchLabels:
      gateway.envoyproxy.io/owning-gateway-namespace: gateway-infrastructure
      gateway.envoyproxy.io/owning-gateway-name: default
  endpoints:
    - port: metrics
      interval: 30s
      path: /stats/prometheus
```

### Recommended Alerts

```yaml
# Example Prometheus alerts
groups:
  - name: gateway-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(envoy_http_downstream_rq_xx{envoy_response_code_class="5"}[5m])) /
          sum(rate(envoy_http_downstream_rq_xx[5m])) > 0.05
        for: 5m
        annotations:
          summary: "High 5xx error rate on gateway"
      
      - alert: HighLatency
        expr: |
          histogram_quantile(0.99,
            sum(rate(envoy_http_downstream_rq_time_bucket[5m])) by (le)
          ) > 1000
        for: 5m
        annotations:
          summary: "P99 latency above 1s"
      
      - alert: GatewayDown
        expr: up{job="envoy-gateway"} == 0
        for: 1m
        annotations:
          summary: "Gateway is down"
```

## Security Hardening Checklist

- [ ] TLS 1.3 minimum enforced
- [ ] Strong cipher suites configured
- [ ] Certificate rotation automated
- [ ] HTTP to HTTPS redirect enabled
- [ ] CORS policy configured appropriately
- [ ] Rate limiting enabled
- [ ] Request size limits configured
- [ ] Client IP detection configured
- [ ] Security headers added (via HTTPRoute filters)
- [ ] Access logs enabled for audit
- [ ] Network policies restrict traffic to gateway pods
- [ ] RBAC prevents unauthorized Gateway modification

## Application Team Guidelines

### Creating an HTTPRoute

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-app-route
  namespace: my-app-namespace
spec:
  parentRefs:
    - name: default
      namespace: gateway-infrastructure  # Reference the shared gateway
  
  hostnames:
    - "myapp.example.com"
  
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /api
      backendRefs:
        - name: my-backend-service
          port: 8080
      
      # Optional: Add security headers
      filters:
        - type: ResponseHeaderModifier
          responseHeaderModifier:
            add:
              - name: X-Content-Type-Options
                value: nosniff
              - name: X-Frame-Options
                value: DENY
              - name: X-XSS-Protection
                value: "1; mode=block"
              - name: Strict-Transport-Security
                value: "max-age=31536000; includeSubDomains"
```

### Discovering the Gateway

```bash
# List available gateways
kubectl get gateway -n gateway-infrastructure

# Get gateway details
kubectl describe gateway default -n gateway-infrastructure

# Get gateway service endpoint
kubectl get svc -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=default
```

## Troubleshooting

### Check Gateway Status

```bash
# Gateway resource status
kubectl get gateway default -n gateway-infrastructure -o yaml

# Gateway controller logs
kubectl logs -n envoy-gateway-system -l control-plane=envoy-gateway

# Envoy proxy logs
kubectl logs -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=default
```

### Check HTTPRoute Status

```bash
# Route status
kubectl get httproute -n my-app-namespace -o yaml

# Check if route is accepted
kubectl get httproute my-app-route -n my-app-namespace \
  -o jsonpath='{.status.parents[0].conditions}'
```

### Common Issues

1. **HTTPRoute not working**
   - Verify `parentRefs` references correct Gateway namespace
   - Check Gateway `allowedRoutes` namespace selector
   - Verify hostname matches Gateway listener hostname

2. **TLS issues**
   - Verify certificate Secret exists in gateway namespace
   - Check certificate validity and expiration
   - Ensure SNI hostname matches

3. **Rate limiting not working**
   - Verify rate limit service is deployed
   - Check BackendTrafficPolicy is applied
   - Review rate limit service logs

## Future Enhancements

- [ ] Add WAF integration (e.g., ModSecurity)
- [ ] Implement geo-blocking
- [ ] Add advanced traffic splitting (A/B testing)
- [ ] Integrate with external auth providers
- [ ] Set up multi-cluster gateway federation
- [ ] Implement circuit breaking policies
- [ ] Add custom access log formats per team
- [ ] Implement tenant isolation with namespace quotas

## References

- [Envoy Gateway Documentation](https://gateway.envoyproxy.io/)
- [Gateway API Specification](https://gateway-api.sigs.k8s.io/)
- [Envoy Proxy Documentation](https://www.envoyproxy.io/)
