# Pods cleanup Helm chart

A Helm chart to schedule deletion of pods by their statuses daily in the specified namespace of the cluster.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `cronConfig` | Map of objects. The key of the map should be the name of the configurations to be used and the value should be the desired value for the cronjob to run | `{}`                  |

## Cronjob Configurations

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `cronName`        | Name of the cronjob to be created       | `null`  |
| `schedule`      | The schedule at which the cronjob should run               | `null`  |
| `command` | The command that a cronjob should run      | `null`  |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install helm install [RELEASE_NAME] facets-cloud/gke-pods-cleanup -f gke-pods-cleanup/values.yaml
```

## Sample Values
```yaml
image: "busybox"
schedule: "45 12 * * *"
podStatusesToCleanUp: "Running|Completed"
filter: "Running"
namespace: "kube-system"
```
