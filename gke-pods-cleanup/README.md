# Gke pods cleanup Helm chart

A Helm chart to schedule deletion of pods with NodeShutdown and Terminated state daily in gke clusters.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `image` | The image with which cronjob will create a job to delete the specified pods | `null` |
| `schedule` | The scheduled time at which the deletion of pods would take place | `null` |
| `podStatusesToCleanUp` | The status of the pod which is to be deleted | `null` |
| `namespace` | The namespace from where the pods are to be deleted | `default` |
| `filter` | The current status of the pod | `null` |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install helm install [RELEASE_NAME] facets-cloud/gke-pods-cleanup -f gke-pods-cleanup/values.yaml
```

## Sample Values
```yaml
image: "busybox"
schedule: "45 12 * * *"
podStatusesToCleanUp: "Running|Completed|NodeShutdowm|Terminated"
filter: "Succeeded"
namespace: "kube-system"
```
