# Scheduled Deployment Scaler Helm Chart

A Helm chart to schedule replicas updates of your Kubernetes Deployments.

## Chart Configuration

The following table lists the configurable parameters of the Scheduled Deployment Scaler chart and their default values.

| Parameter           | Description                                                                                                                                                                            | Default               |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `scalingSchedules`  | Map of objects, each defining a schedule to update replicas of a deployment. The key of the map is used as the name of the schedule. (see [Schedules Object](#schedules-object) for details) | `{}`                  |

## Schedules Object

| Parameter         | Description                                                                                                                 | Default |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `schedule`        | The schedule in cron format. (timezone is UTC)                                                                                | `null`  |
| `deployment`      | The name of the deployment to scale                                                                                           | `null`  |
| `desiredReplicas` | The desired number of replicas of the deployment after the scale operation                                                     | `null`  |
| `namespace`       | The namespace of the deployment. If not provided, defaults to `default` namespace.                                            | `null`  |
