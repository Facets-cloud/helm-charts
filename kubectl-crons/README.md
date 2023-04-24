# Schedule pods cleanup Helm chart

A Helm chart to schedule deletion of pods by their statuses daily in the specified namespace of the cluster.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `cronConfig` | Map of objects. The key of the map should be the name of the configurations to be used and the value should be the desired value for the cronjob to run | `{}`                  |
| `tolerations` | The tolerations to be added to the pod created by cronjob     | `null`  |

## Cronjob Configurations

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `cronName`        | Name of the cronjob to be created       | `null`  |
| `schedule`      | The schedule at which the cronjob should run               | `null`  |
| `command` | The command that a cronjob should run      | `null`  |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install helm install [RELEASE_NAME] facets-cloud/kubectl-crons -f kubectl-crons/values.yaml
```

## Sample Values
```yaml
cronConfig:
- cronName: "cleanup-pending-pods"
  schedule: "0 * * * *"
  command: "kubectl get pod --field-selector=status.phase='Pending'| grep -E 'Pending' | awk '{print $1}' | xargs -r kubectl delete pod"
- cronName: "cleanup-completed-success-pods"
  schedule: "30 15 * * *"
  command: "kubectl get pod --field-selector=status.phase='Succeeded'| grep -E 'Completed' | awk '{print $1}' | xargs -r kubectl delete pod"

```
