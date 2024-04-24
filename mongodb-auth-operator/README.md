# Helm Chart for MongoDB Auth Operator

This Helm chart deploys the MongoDB Auth Operator on a Kubernetes cluster using the Helm package manager.

The MongoDB Auth Operator is designed to aid in user management within a deployed MongoDB cluster, such as a Bitnami MongoDB cluster. By utilizing Users and Roles resources, this operator allows for the effective management of custom MongoDB users and their respective roles.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Configuration

The following table lists the configurable parameters of the MongoDB Operator chart and their default values from `values.yaml`.

| Parameter                                                  | Description                                          | Default                                                                                                    |
|------------------------------------------------------------|------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| `controllerManager.replicas`                               | Number of Controller Manager replicas                | `1`                                                                                                        |
| `controllerManager.kubeRbacProxy.args`                     | Arguments passed to the Kube Rbac Proxy              | `--secure-listen-address=0.0.0.0:8443`, `--upstream=http://127.0.0.1:8080/`, `--logtostderr=true`, `--v=0` |
| `controllerManager.kubeRbacProxy.image.repository`         | Image repository for the Kube Rbac Proxy             | `gcr.io/kubebuilder/kube-rbac-proxy`                                                                       |
| `controllerManager.kubeRbacProxy.image.tag`                | Image tag for the Kube Rbac Proxy                    | `v0.13.1`                                                                                                  |
| `controllerManager.kubeRbacProxy.resources`                | Resource requests and limits for the Kube Rbac Proxy | Limits: `cpu: 500m, memory: 128Mi`, Requests: `cpu: 5m, memory: 64Mi`                                      |
| `controllerManager.kubeRbacProxy.containerSecurityContext` | Security context for the Kube Rbac Proxy container   | `allowPrivilegeEscalation: false`, `capabilities.drop: ALL`                                                |
| `controllerManager.manager.args`                           | Arguments passed to the Manager                      | `--health-probe-bind-address=:8081`, `--metrics-bind-address=127.0.0.1:8080`, `--leader-elect`             |
| `controllerManager.manager.image.repository`               | Image repository for the Manager                     | `facetscloud/mongodb-auth-operator`                                                                        |
| `controllerManager.manager.image.tag`                      | Image tag for the Manager                            | `1`                                                                                                        |
| `controllerManager.manager.resources`                      | Resource requests and limits for the Manager         | Limits: `cpu: 500m, memory: 128Mi`, Requests: `cpu: 10m, memory: 64Mi`                                     |
| `controllerManager.manager.containerSecurityContext`       | Security context for the Manager container           | `allowPrivilegeEscalation: false`, `capabilities.drop: ALL`                                                |
| `kubernetesClusterDomain`                                  | Domain of your Kubernetes cluster                    | `cluster.local`                                                                                            |
| `metricsService.ports`                                     | Ports for the Metrics Service                        | `name: https, port: 8443, protocol: TCP, targetPort: https`                                                |
| `metricsService.type`                                      | Type of the Metrics Service                          | `ClusterIP`                                                                                                |

## Installation

To install the chart with the release name `my-release`:

```bash
helm install my-release .
```

This command deploys the MongoDB Operator on the Kubernetes cluster with the default configuration.

For more information on the usage of Helm, refer to the [Helm documentation](https://helm.sh/docs/).
