# Image Pull Secret Injector

This Helm chart deploys a Kubernetes admission webhook that automatically injects image pull secrets into pods. It's useful for clusters that need to pull images from private registries without explicitly specifying the pull secrets in each deployment.

## Description

The Image Pull Secret Injector is a Kubernetes admission webhook that mutates pods during creation to inject specified image pull secrets. This eliminates the need to manually configure image pull secrets in each deployment, making it easier to manage access to private container registries across your cluster.

## Features

- Automatically injects configured image pull secrets into pods
- Supports multiple registry secrets
- Configurable via Helm values
- Includes health and metrics endpoints
- Runs as a secure webhook with TLS

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `image-pull-secret-injector`:

```bash
helm install image-pull-secret-injector .
```

## Configuration

The following table lists the configurable parameters of the chart and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas to run | `3` |
| `image.repository` | Image repository | `facetscloud/image-pull-secrets` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `1` |
| `secretList` | Comma-separated list of secrets to inject | `registry-secret-test-google-container,registry-secret-test-pass-azure` |
| `debug` | Enable debug logging | `false` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Webhook service port | `443` |
| `service.targetPort` | Webhook container port | `9443` |
| `service.metrics.port` | Metrics endpoint port | `8080` |
| `service.health.port` | Health endpoint port | `8081` |

### Example Configuration

```yaml
# values.yaml
replicaCount: 1
secretList: "my-registry-secret,another-registry-secret"
debug: true
```

## Usage

Once installed, the webhook will automatically inject the specified image pull secrets into new pods. No additional configuration is needed in your deployments.

The webhook will add the secrets specified in `secretList` to the `imagePullSecrets` field of any new pods created in the cluster.

## Monitoring

The service exposes the following endpoints:
- Health check: `:8081/healthz`
- Metrics: `:8080/metrics`

## Security

The webhook runs with TLS enabled by default. The service account has minimal permissions required for the webhook to function.

## License

This Helm chart is available under the Apache 2.0 license.
