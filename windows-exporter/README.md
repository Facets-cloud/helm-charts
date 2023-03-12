# Windows Exporter DaemonSet and Pod Monitor Helm Chart

A Helm chart to deploy a DaemonSet and Pod Monitor for Windows nodes.

## Values

The following table lists the values accepted by the chart

| Key                | Description                                                                                                                           | Default               |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------| --------------------- |
| `namespace` | The namespace to deploy the chart | `default`                  |
| `podMonitor` | Map of objects to configure a PodMonitor. The key of the map should be the name of the configurations to be used and the value should be the desired value for the PodMonitor to run | `{}` |
| `windowsExporter` | Map of objects to configure the Windows Exporter DaemonSet. The key of the map should be the name of the configurations to be used and the value should be the desired value for the DaemonSet to run | `{}` |
| `configMap` | Map of objects to configure the ConfigMap. The key of the map should be the name of the configurations to be used and the value should be the desired value for the ConfigMap to run | `{}` |

## PodMonitor Configurations

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `fullname`        | Fullname of the PodMonitor to be created       | `windows-exporter-podmonitor`  |
| `jobLabel`      | The label of the job this PodMonitor targets               | `windows-exporter`  |
| `labels` | Labels to add to the PodMonitor      | `app: windows-exporter`<br>`release: prometheus-operator`  |
| `selectorLabels` | Labels used to select pods      | `app: windows-exporter`  |

## Windows Exporter DaemonSet Configurations

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `fullname`        | Fullname of the DaemonSet to be created       | `windows-exporter-daemonset`  |
| `hostPort`      | The host port to bind for the metrics endpoint               | `9182`  |
| `metricsPortname` | Name of the port where metrics are exposed on the pods      | `http-web`  |
| `labels` | Labels to add to the DaemonSet      | `app: windows-exporter`  |
| `selectorLabels` | Labels used to select pods      | `app: windows-exporter`  |
| `nodeSelector` | Node selector to use to select nodes where the DaemonSet runs      | `kubernetes.io/os: windows`  |
| `tolerations` | Tolerations to add to the DaemonSet      | `- effect: NoSchedule`<br>`  key: kubernetes.azure.com/scalesetpriority`<br>`  operator: Equal`<br>`  value: spot`<br>`- effect: NoSchedule`<br>`  key: dedicated`<br>`  operator: Equal`<br>`  value: windowsnode`  |

## ConfigMap Configurations

| Key               | Description                                                                                                                 | Default |
|-------------------| ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `configMapName`        | Name of the ConfigMap to be created       | `windows-exporter-config`  |
| `config`      | Configuration data to add to the ConfigMap               | `collectors: enabled: '[defaults],container'`<br>`collector:`<br>`  service:`<br>`    services-where: "Name='containerd' or Name='kubelet'"`  |

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install [RELEASE_NAME] facets-cloud/windows-exporter -f [VALUES_FILE]
```


