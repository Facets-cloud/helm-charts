# Scheduled Deployment Scaler Helm Chart

A Helm chart to add logging substack that includes fluentd, wetty and wetty-ssh resource for azure cloud only.

## Values

To enable the utilisation of existing volume in wetty-ssh resource. 
- enable `wettysshAdditionalVolumes.enabled` **true**
- Add the volume details to be mounted additionally to wetty-ssh resource 
    - Required : `name`,`mountPath` & `claimName` 
- Ensure that added volumes already exist in the cluster. 
```yaml
wettysshAdditionalVolumes:
  enabled: true
  pvcNames:
    - name: logs-vol
      mountPath: /var/log/efs
      claimName: logs-pvc
```

## Usage

```bash
helm repo add facets-cloud https://facets-cloud.github.io/helm-charts

helm install helm install myrelease facets-cloud/azure-logging-stack 
```