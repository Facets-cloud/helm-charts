# Scheduled Deployment Scaler Helm Chart

A Helm chart to add logging substack that includes fluentd, wetty and wetty-ssh resource for azure cloud only.

## Values

- Toleration used for azure spot nodes: 
```yaml
global:
  tolerations:
    effect: NoSchedule
    key: kubernetes.azure.com/scalesetpriority
    operator: Equal
    value: spot
```
To enable the utilisation of existing volume in wetty-ssh resource. 
- enable `wettysshAdditionalVolumes.enabled` **true**
- Add the volume details to be mounted additionally to wetty-ssh resource 
    - Required : `name`,`mountPath` & `claimName` 
- Ensure that added volumes already exist in the cluster. 
```yaml
wettySsh:
  wettysshAdditionalVolumes:
    pvcAdditional:
      - name: logs-vol
        mountPath: /var/log/efs
        claimName: logs-pvc
```
# wettySsh

| Parameter                                                  | Description                                                                                         | Default                                                                  |
|------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `wettySsh.name`                                            | Name of the Wetty SSH deployment                                                                    | `wetty-ssh`                                                              |
| `wettySsh.image`                                           | Docker image for the Wetty SSH container                                                            | `313496281593.dkr.ecr.us-east-1.amazonaws.com/wetty-ssh-host:30a4b00-16` |
| `wettySsh.resources.limits.cpu`                            | Maximum CPU usage allowed for the container                                                         | `0.5`                                                                    |
| `wettySsh.resources.limits.memory`                         | Maximum memory usage allowed for the container                                                      | `1Gi`                                                                    |
| `wettySsh.wettysshAdditionalVolumes.enabled`               | Enable additional volumes for the Wetty SSH container                                               | `false`                                                                  |
| `wettySsh.wettysshAdditionalVolumes.pvcAdditional`              | List of additional volumes to mount in the Wetty SSH container, specified as a list of dictionaries | `[]`                                                                     |
| `wettySsh.wettysshAdditionalVolumes.pvcAdditional[0].name`      | Name of the additional volume to mount in the container                                             | NA                                                                       |
| `wettySsh.wettysshAdditionalVolumes.pvcNampvcAdditionales[0].mountPath` | Mount path of the additional volume in the container                                                | NA                                                                       |
| `wettySsh.wettysshAdditionalVolumes.pvcAdditional[0].claimName` | Name of the Persistent Volume Claim (PVC) used for the additional volume                            | NA                                                                       |


# wetty 

| Parameter                          | Description                                                | Default           |
| --------------------------------- | ---------------------------------------------------------- | ----------------- |
| `wetty.replicaCount`              | Number of replicas                                         | `1`               |
| `wetty.image.repository`          | Docker image repository                                    | `313496281593.dkr.ecr.us-east-1.amazonaws.com/wetty-app:6c9d009-10` |
| `wetty.image.pullPolicy`          | Docker image pull policy                                   | `IfNotPresent`    |
| `wetty.imagePullPolicy`           | Docker image pull policy                                   | `IfNotPresent`    |
| `wetty.livenessProbe.failureThreshold` | Failure threshold for liveness probe                | `20`              |
| `wetty.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probe is initiated | `30` |
| `wetty.livenessProbe.periodSeconds` | How often the liveness probe is executed              | `10`              |
| `wetty.livenessProbe.successThreshold` | Number of successful liveness probe executions required for the container to be considered alive | `1` |
| `wetty.livenessProbe.tcpSocket.port` | Port number used for the liveness probe TCP socket     | `3000`            |
| `wetty.livenessProbe.timeoutSeconds` | Number of seconds after which the liveness probe times out | `10`           |
| `wetty.readinessProbe.failureThreshold` | Failure threshold for readiness probe              | `20`              |
| `wetty.readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before readiness probe is initiated | `30` |
| `wetty.readinessProbe.periodSeconds` | How often the readiness probe is executed            | `10`              |
| `wetty.readinessProbe.successThreshold` | Number of successful readiness probe executions required for the container to be considered ready | `1` |
| `wetty.readinessProbe.tcpSocket.port` | Port number used for the readiness probe TCP socket   | `3000`            |
| `wetty.readinessProbe.timeoutSeconds` | Number of seconds after which the readiness probe times out | `10`         |
| `wetty.resources.limits.cpu`     | Maximum CPU usage allowed for the container               | `125m`            |
| `wetty.resources.limits.memory`  | Maximum memory usage allowed for the container            | `512Mi`           |
| `wetty.resources.requests.cpu`   | Minimum CPU usage required for the container              | `125m`            |
| `wetty.resources.requests.memory`| Minimum memory usage required for the container           | `512Mi`           |

# fluentd

| Parameter                        | Description                                                                                              | Default                                                   |
| -------------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `fluentd.name`                   | Name of the Fluentd deployment                                                                           | `fluentd`                                                 |
| `fluentd.image.repository`       | Docker image repository for Fluentd container                                                            | `313496281593.dkr.ecr.us-east-1.amazonaws.com/fluentd-efs:new` |
| `fluentd.imagePullPolicy`        | Image pull policy for the Fluentd container                                                              | `IfNotPresent`                                            |
| `fluentd.resources.limits.cpu`   | Maximum CPU usage allowed for the Fluentd container                                                       | `0.25`                                                    |
| `fluentd.resources.limits.memory`| Maximum memory usage allowed for the Fluentd container                                                    | `1Gi`                                                     |
| `fluentd.restartPolicy`          | Restart policy for the Fluentd container                                                                 | `Always`                                                  |
| `fluentd.priorityClass.name`     | Name of the priority class assigned to the Fluentd DaemonSet                                             | `infra-critical-daemonset`                                |

# logsVolume

| Parameter                                       | Description                                            | Default    |
|-------------------------------------------------|--------------------------------------------------------|------------|
| `logsVolume.persistentVolumeClaims`             | Configuration for the persistent volume claim          |            |
| `logsVolume.persistentVolumeClaims.storageSize` | Requested storage size for the persistent volume claim | `20Gi`     |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install myrelease facets-cloud/azure-logging-stack 
```