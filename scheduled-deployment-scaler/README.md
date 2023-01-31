# Scheduled Deployment Scaler Helm Chart

A Helm chart to schedule replica count updates for your Kubernetes Deployments.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                               | Default               |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `scalingSchedules` | Map of objects. The key of the map is used as the name of the schedule. (Value is of type [Schedule](#schedule-object) for details) | `{}`                  |

## Schedule Object

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `schedule`        | The schedule in cron format. (timezone is UTC)                                                                                | `null`  |
| `deployment`      | The name of the deployment to scale                                                                                           | `null`  |
| `desiredReplicas` | The desired number of replicas of the deployment after the scale operation                                                     | `null`  |
| `namespace`       | The namespace of the deployment. If not provided, defaults to `default` namespace.                                            | `null`  |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install helm install myrelease facets-cloud/scheduled-deployment-scaler -f my-scaling-schedules.yaml
```

## Sample Values

```yaml
scalingSchedules:
  schedule1:
    schedule: "0 45 22 * * *"
    deployment: deployment1
    desiredReplicas: 4
    namespace: default
  schedule2:
    schedule: "0 0 * * * *"
    deployment: deployment2
    desiredReplicas: 2
    namespace: test-namespace
```