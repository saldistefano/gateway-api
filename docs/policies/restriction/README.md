# Restriction Policies

These Kyverno policies prevent LOB teams from creating unapproved gateways and enforce compliance requirements.

## Policy Files

| Policy | Severity | Description |
|--------|----------|-------------|
| [restrict-gateway-creation.yaml](restrict-gateway-creation.yaml) | High | Prevents unauthorized Gateway creation outside approved namespaces |
| [enforce-gateway-class.yaml](enforce-gateway-class.yaml) | Medium | Ensures all Gateways use the 'eg' GatewayClass |
| [require-gateway-tls.yaml](require-gateway-tls.yaml) | High | Requires TLS configuration on all HTTPS listeners |
| [protect-gateway-deletion.yaml](protect-gateway-deletion.yaml) | Medium | Requires approval annotation before Gateway deletion |
| [gateway-resource-limits.yaml](gateway-resource-limits.yaml) | Medium | Limits Gateway to maximum 4 listeners |
| [enforce-same-namespace-gateway-reference.yaml](enforce-same-namespace-gateway-reference.yaml) | High | Ensures HTTPRoutes/GRPCRoutes only reference Gateways in same namespace |

## Installation

Apply all restriction policies:

```bash
kubectl apply -f docs/policies/restriction/
```

Apply individual policy:

```bash
kubectl apply -f docs/policies/restriction/enforce-gateway-class.yaml
```

## Testing

Test policies before applying:

```bash
# Test with kubectl kyverno CLI
kubectl kyverno apply restrict-gateway-creation.yaml --resource test-gateway.yaml

# Dry-run validation
kubectl apply -f gateway.yaml --dry-run=server
```

## Monitoring

Check policy status:

```bash
# View policy status
kubectl get clusterpolicy

# Check policy violations
kubectl get policyreport -A

# View specific policy
kubectl describe clusterpolicy restrict-gateway-creation
```
