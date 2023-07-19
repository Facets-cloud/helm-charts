# Scheduled HPA Updater Helm Chart

A Helm chart to schedule updates for your Kubernetes Horizontal Pod Autoscaler (HPA) minReplicas, maxReplicas, and cpuPercent values.

## Values

The following table lists the configurable values of the Scheduled HPA Updater chart and their default values.

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `scalingSchedules` | Map of objects. The key of the map is used as the name of the schedule. Value must be of type [Schedule](#schedule-object) | `{}`                  |

## Schedule Object

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `schedule`        | The schedule in cron format. (timezone is UTC)                                                                                | `null`  |
| `hpa`             | The name of the Horizontal Pod Autoscaler to update                                                                                           | `null`  |
| `minReplicas`     | The minimum number of replicas to set in the HPA after the update operation                                                     | `null`  |
| `maxReplicas`     | The maximum number of replicas to set in the HPA after the update operation                                                     | `null`  |
| `cpuPercent`      | The target CPU utilization percentage to set in the HPA after the update operation                                                     | `null`  |
| `namespace`       | The namespace of the HPA. If not provided, defaults to `default` namespace.                                            | `null`  |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install myrelease facets-cloud/scheduled-hpa-updater -f my-scaling-schedules.yaml
```

## Sample Values

```yaml
scalingSchedules:
  schedule1:
    schedule: "0 45 22 * * *"
    hpa: hpa1
    minReplicas: 2
    maxReplicas: 4
    cpuPercent: 80
    namespace: default
  schedule2:
    schedule: "0 0 * * * *"
    hpa: hpa2
    minReplicas: 1
    maxReplicas: 2
    cpuPercent: 70
    namespace: test-namespace
```

This Helm chart allows you to schedule updates to your Kubernetes HPAs. You can specify the minimum and maximum number of replicas and the target CPU utilization percentage for each HPA, and these values will be updated at the specified schedule. This can be useful for adjusting the scaling behavior of your applications based on predictable load patterns.