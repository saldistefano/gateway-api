# Administrative Policies (Auto-Generation)

These Kyverno policies automatically create default gateways and supporting resources for LOB application namespaces.

## Policy Files

| Policy | Resources Generated | Description |
|--------|---------------------|-------------|
| [generate-lob-gateway.yaml](generate-lob-gateway.yaml) | Gateway | Creates default Gateway with HTTP/HTTPS listeners |
| [generate-lob-wildcard-cert.yaml](generate-lob-wildcard-cert.yaml) | Secret (TLS) | Clones wildcard certificate template for namespace |
| [generate-lob-https-redirect.yaml](generate-lob-https-redirect.yaml) | HTTPRoute | Creates HTTP to HTTPS redirect route |
| [generate-lob-security-policy.yaml](generate-lob-security-policy.yaml) | SecurityPolicy | Applies TLS 1.3, ciphers, and CORS settings |
| [generate-lob-traffic-policy.yaml](generate-lob-traffic-policy.yaml) | ClientTrafficPolicy | Configures timeouts, limits, and HTTP/2 settings |

## Trigger

All policies are triggered for **any namespace that does NOT have the `system` label**.

To exclude a namespace from auto-generation, label it:

```yaml
metadata:
  labels:
    system: "true"  # Excludes this namespace from gateway auto-generation
```

**System namespaces** (automatically excluded):
- `kube-system`
- `kube-public`
- `kube-node-lease`
- `default`
- `ics-envoy-gateway`
- `envoy-gateway-system`
- `kyverno`

Label these with `system: "true"` to prevent auto-generation.

## Generated Resources

For a namespace named `finance`, these policies will create:

- `finance-gateway` - Gateway resource
- `finance-wildcard-tls` - TLS certificate Secret
- `finance-https-redirect` - HTTPRoute for HTTPS redirect
- `finance-security` - SecurityPolicy
- `finance-traffic` - ClientTrafficPolicy

## Installation

Apply all administrative policies:

```bash
kubectl apply -f docs/policies/administrative/
```

Apply individual policy:

```bash
kubectl apply -f docs/policies/administrative/generate-lob-gateway.yaml
```

## Prerequisites

Before applying these policies, create the certificate template:

```bash
# Create wildcard certificate template in ics-envoy-gateway namespace
kubectl create secret tls wildcard-cert-template \
  --cert=path/to/cert.crt \
  --key=path/to/cert.key \
  -n ics-envoy-gateway
```

## Testing

Create a test namespace to verify auto-generation:

```bash
# Create namespace (will auto-generate gateway resources)
kubectl create namespace test-lob

# Verify resources were created
kubectl get gateway,secret,httproute,securitypolicy,clienttrafficpolicy -n test-lob

# Cleanup
kubectl delete namespace test-lob
```

## Monitoring

Check generated resources:

```bash
# View generated resources for a namespace
kubectl get all,gateway,httproute,securitypolicy,clienttrafficpolicy -n <namespace>

# Check policy reports
kubectl get policyreport -n <namespace>

# View policy events
kubectl get events -n kyverno --field-selector reason=PolicyApplied
```

## Certificate Management

The `generate-lob-wildcard-cert` policy clones a template certificate. For production, integrate with cert-manager:

1. Install cert-manager
2. Create ClusterIssuer (e.g., Let's Encrypt)
3. Modify the policy to generate Certificate resources instead of Secrets
4. cert-manager will automatically provision real certificates
