# Gke pods cleanup Helm chart

A Helm chart to schedule deletion of pods with NodeShutdown and Terminated state daily in gke clusters.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `image` | The image with which cronjob will create a job to delete the specified pods | `null` |
| `schedule` | The scheduled time at which the deletion of pods would take place | `null` |