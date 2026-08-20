# IAC Operator Helm Chart

This Helm chart deploys the Infrastructure as Code (IaC) Release Operator for Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8+
- kubectl configured to communicate with your cluster

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
| `image.repository` | Operator image repository | `facetscloud/iac-operator` |
| `image.tag` | Operator image tag; must be `operator-v<appVersion>` | `operator-v1.1.1` |
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

| `operator.metricsSecure` | Serve /metrics over HTTPS with authz. The shipped ServiceMonitor sets no `scheme`, `tlsConfig` or `bearerTokenFile`, so it keeps scraping over HTTP and breaks. Editing the template is the only way to scrape a secure endpoint | `false` |
| `operator.leaderElection.resourceName` | Leader-election lease name | `iac-operator-leader` |
| `operator.leaderElection.resourceNamespace` | Lease namespace (empty = release namespace) | `""` |
| `operator.releaseSweeper.enabled` | Prune old Releases per environment | `false` |
| `operator.releaseSweeper.interval` | Sweep interval | `15m` |
| `operator.releaseSweeper.maxReleasesPerEnv` | Releases kept per environment | `10` |
| `operator.releaseSweeper.triggerThreshold` | Release count that triggers a sweep | `15` |
| `operator.releaseSweeper.runOnStartup` | Sweep once at startup | `false` |

### RBAC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |
| `rbac.create` | Create RBAC resources | `true` |

| `rbac.additionalRules` | Extra rules appended to the manager ClusterRole | `[]` |

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

| `serviceMonitor.annotations` | Annotations on the ServiceMonitor | `{}` |

### Webhook Configuration

The webhook's serving certificate is provisioned by a self-contained pre-install
Job (`kube-webhook-certgen`): it generates a self-signed cert into
`webhook.certSecret` and patches the CA bundle into the webhook configuration.
No cert-manager dependency.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webhook.enabled` | Enable admission webhooks | `true` |
| `webhook.port` | Webhook server port | `9443` |
| `webhook.certSecret` | Secret name for webhook certificates | `webhook-server-cert` |
| `webhook.failurePolicy` | Webhook failure policy (Fail/Ignore) | `Fail` |
| `webhook.timeoutSeconds` | Webhook timeout in seconds | `10` |
| `webhook.service.type` | Webhook service type | `ClusterIP` |
| `webhook.service.annotations` | Webhook service annotations | `{}` |

| `webhook.certgen.image.repository` | certgen image (issues the webhook cert; no cert-manager needed) | `registry.k8s.io/ingress-nginx/kube-webhook-certgen` |
| `webhook.certgen.image.tag` | certgen image tag | `v1.4.4` |
| `webhook.certgen.image.pullPolicy` | certgen pull policy | `IfNotPresent` |
| `webhook.certgen.resources` | certgen job resources | `{}` |

### API Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `api.enabled` | Enable custom API endpoints | `true` |
| `api.service.type` | API service type | `ClusterIP` |
| `api.service.port` | API service port | `9090` |
| `api.service.nodePort` | NodePort (if type is NodePort) | `null` |
| `api.service.annotations` | API service annotations | `{}` |
| `api.ingress.enabled` | Enable Ingress for API | `false` |
| `api.ingress.className` | Ingress class name | `nginx` |
| `api.ingress.annotations` | Ingress annotations | `{}` |
| `api.ingress.hosts` | Ingress host configuration | See values.yaml |
| `api.ingress.tls` | TLS configuration | `[]` |

| `api.port` | Container port the API listens on | `9090` |

### CRD Management

| Parameter | Description | Default |
|-----------|-------------|---------|
| `crds.install` | Present in `values.yaml` but read by no template. CRDs are always installed | `true` |
| `crds.keep` | Present in `values.yaml` but read by no template. It does not protect CRDs on uninstall | `false` |

> **`helm uninstall` deletes the CRDs and every custom resource in them.** The CRD
> templates carry no `helm.sh/resource-policy: keep`, and neither `crds.install` nor
> `crds.keep` is wired up, so uninstalling removes `releases`, `releasetemplates` and
> `projecttypes` along with every `Release`, `ReleaseTemplate` and `ProjectType`
> object. Back those up first.

### Pod Placement and Security

| Parameter | Description | Default |
|---|---|---|
| `resources.limits.cpu` / `.memory` | Operator container limits | `1000m` / `1Gi` |
| `resources.requests.cpu` / `.memory` | Operator container requests | `500m` / `512Mi` |
| `autoscaling.enabled` | Enable an HPA for the operator | `false` |
| `autoscaling.minReplicas` / `.maxReplicas` | HPA bounds | `1` / `3` |
| `autoscaling.targetCPUUtilizationPercentage` | HPA CPU target | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | HPA memory target | `80` |
| `podAnnotations` | Annotations on the operator pod | `{}` |
| `podSecurityContext` | Pod security context (non-root, uid/fsGroup 65532) | see `values.yaml` |
| `securityContext` | Container security context (no privilege escalation, all caps dropped, read-only rootfs) | see `values.yaml` |
| `nodeSelector` / `tolerations` / `affinity` | Standard scheduling controls | `{}` / `[]` / `{}` |
| `config.env` | Extra env vars for the operator container | `{}` |
| `config.volumes` / `config.volumeMounts` | Extra volumes and mounts | `[]` / `[]` |

## Uninstallation

```bash
helm uninstall iac-operator -n iac-operator-system
```

If you want to delete the CRDs as well:

```bash
kubectl delete crd releases.iac.facets.cloud
kubectl delete crd releasetemplates.iac.facets.cloud
kubectl delete crd projecttypes.iac.facets.cloud
```

## Examples

### Install with custom values

Create a `values.yaml` file:

```yaml
operator:
  logLevel: debug

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
    port: 9090
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