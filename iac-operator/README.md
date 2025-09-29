# IAC Operator Helm Chart

This Helm chart deploys the Infrastructure as Code (IaC) Release Operator for Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8+
- kubectl configured to communicate with your cluster
- cert-manager installed in the cluster (for webhook certificates)

## Installation

### Add the Helm repository (if available)

```bash
helm repo add facets https://facets-cloud.github.io/helm-charts
helm repo update
```

### Install the chart

```bash
# Install from local directory
helm install iac-operator facets/iac-operator -n iac-operator-system --create-namespace

# Or with custom values
helm install iac-operator ./helm-chart/iac-operator \
  -n iac-operator-system \
  --create-namespace \
  -f my-values.yaml
```

## Configuration

The following table lists the configurable parameters of the IAC Operator chart and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of operator replicas | `1` |
| `image.repository` | Operator image repository | `facets/iac-operator` |
| `image.tag` | Operator image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Image pull secrets | `[]` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full name | `""` |

### Operator Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.logLevel` | Log level (debug, info, warn, error) | `info` |
| `operator.metricsPort` | Metrics server port | `8080` |
| `operator.healthPort` | Health probe port | `8081` |
| `operator.leaderElection.enabled` | Enable leader election | `true` |
| `operator.watchNamespace` | Namespace to watch (empty = all) | `""` |
| `operator.maxConcurrentReconciles` | Max concurrent reconciles | `1` |

### IAC Generator Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.iacGenerator.image` | IAC Generator image | `facets/iac-generator:latest` |
| `operator.iacGenerator.version` | IAC Generator version | `1.0.0` |
| `operator.iacGenerator.downloadURL` | URL to download IAC Generator | `https://github.com/...` |

### Terraform Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.terraform.image` | Terraform image | `hashicorp/terraform:1.5.7` |

### Pod Resource Defaults

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.podDefaults.resources.limits.cpu` | CPU limit for pods | `2` |
| `operator.podDefaults.resources.limits.memory` | Memory limit for pods | `4Gi` |
| `operator.podDefaults.resources.requests.cpu` | CPU request for pods | `500m` |
| `operator.podDefaults.resources.requests.memory` | Memory request for pods | `1Gi` |

### Queue Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.queue.maxRetries` | Max retry attempts | `3` |
| `operator.queue.retryDelay` | Delay between retries | `30s` |
| `operator.queue.maxQueueSize` | Maximum queue size | `100` |

### Environment Lock Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.environmentLock.enabled` | Enable environment locking | `true` |
| `operator.environmentLock.timeout` | Lock timeout in seconds | `3600` |
| `operator.environmentLock.gcInterval` | Garbage collection interval | `300` |

### RBAC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |
| `rbac.create` | Create RBAC resources | `true` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `service.targetPort` | Target port | `metrics` |
| `service.annotations` | Service annotations | `{}` |

### Monitoring

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceMonitor.enabled` | Create ServiceMonitor for Prometheus | `false` |
| `serviceMonitor.interval` | Scrape interval | `30s` |
| `serviceMonitor.scrapeTimeout` | Scrape timeout | `10s` |
| `serviceMonitor.labels` | Additional labels | `{}` |

### Webhook Configuration

The webhook uses cert-manager for automatic certificate management. The CA bundle is automatically injected into the webhook configuration.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webhook.enabled` | Enable admission webhooks | `true` |
| `webhook.port` | Webhook server port | `9443` |
| `webhook.certSecret` | Secret name for webhook certificates | `webhook-server-cert` |
| `webhook.failurePolicy` | Webhook failure policy (Fail/Ignore) | `Fail` |
| `webhook.timeoutSeconds` | Webhook timeout in seconds | `10` |
| `webhook.service.type` | Webhook service type | `ClusterIP` |
| `webhook.service.annotations` | Webhook service annotations | `{}` |

### API Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `api.enabled` | Enable custom API endpoints | `true` |
| `api.service.type` | API service type | `ClusterIP` |
| `api.service.port` | API service port | `8443` |
| `api.service.nodePort` | NodePort (if type is NodePort) | `null` |
| `api.service.annotations` | API service annotations | `{}` |
| `api.ingress.enabled` | Enable Ingress for API | `false` |
| `api.ingress.className` | Ingress class name | `nginx` |
| `api.ingress.annotations` | Ingress annotations | `{}` |
| `api.ingress.hosts` | Ingress host configuration | See values.yaml |
| `api.ingress.tls` | TLS configuration | `[]` |

### CRD Management

| Parameter | Description | Default |
|-----------|-------------|---------|
| `crds.install` | Install CRDs with chart | `true` |
| `crds.keep` | Keep CRDs on uninstall | `true` |

## Uninstallation

```bash
helm uninstall iac-operator -n iac-operator-system
```

If you want to delete the CRDs as well:

```bash
kubectl delete crd releases.iac.facets.cloud
kubectl delete crd releasetemplates.iac.facets.cloud
```

## Examples

### Install with custom values

Create a `values.yaml` file:

```yaml
operator:
  logLevel: debug
  iacGenerator:
    image: my-registry/iac-generator:v2.0.0
  terraform:
    image: hashicorp/terraform:1.6.0
  
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi

serviceMonitor:
  enabled: true
  interval: 60s
```

Install:

```bash
helm install iac-operator ./helm-chart/iac-operator \
  -n iac-operator-system \
  --create-namespace \
  -f values.yaml
```

### Upgrade the operator

```bash
helm upgrade iac-operator ./helm-chart/iac-operator \
  -n iac-operator-system \
  --reuse-values
```

## API Endpoints

The operator provides custom API endpoints for managing releases:

### Approve a Release Phase
```bash
POST /api/v1/namespaces/{namespace}/releases/{name}/approve
Content-Type: application/json

{
  "phase": "terraform-plan",
  "approvedBy": "john.doe@example.com"
}
```

### Decline a Release Phase
```bash
POST /api/v1/namespaces/{namespace}/releases/{name}/decline
Content-Type: application/json

{
  "phase": "terraform-apply",
  "declinedBy": "jane.doe@example.com",
  "reason": "Changes look risky"
}
```

### Get Release Status
```bash
GET /api/v1/namespaces/{namespace}/releases/{name}/status
```

### Example: Expose API via NodePort
```yaml
api:
  enabled: true
  service:
    type: NodePort
    port: 8443
    nodePort: 30443
```

### Example: Expose API via Ingress
```yaml
api:
  enabled: true
  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: iac-api.example.com
        paths:
          - path: /api/v1
            pathType: Prefix
    tls:
      - secretName: iac-api-tls
        hosts:
          - iac-api.example.com
```

## Troubleshooting

### Check operator logs

```bash
kubectl logs -n iac-operator-system deployment/iac-operator-controller-manager
```

### Check if CRDs are installed

```bash
kubectl get crd | grep facets
```

### Verify operator is running

```bash
kubectl get pods -n iac-operator-system
kubectl get deployment -n iac-operator-system
```

## Support

For issues and questions, please contact support@facets.cloud or create an issue on GitHub.