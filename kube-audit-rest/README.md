# kube-audit-rest

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7c6b957ec970acc705d95a1fac72ea7a15bef9c4](https://img.shields.io/badge/AppVersion-7c6b957ec970acc705d95a1fac72ea7a15bef9c4-informational?style=flat-square)

A helm chart for kube-audit-rest. Self Hosted Audit logs for Kubernetes.

kube-audit-rest originally created by RichardoC
https://github.com/RichardoC/kube-audit-rest/

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `2` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `75` |  |
| deployment.extraArgs | list | `[]` | extra arguments to pass to kube-audit-rest |
| deployment.progressDeadlineSeconds | int | `600` |  |
| deployment.restartPolicy | string | `"Always"` |  |
| deployment.revisionHistoryLimit | int | `10` |  |
| deployment.terminationGracePeriodSeconds | int | `30` |  |
| fullnameOverride | string | `""` |  |
| hooks.postInstallArgs | string | `"echo \"post hook\" && bash ./scripts/post-install-entrypoint.sh"` |  |
| hooks.preInstallArgs | string | `"echo \"pre hook\" && bash ./scripts/pre-install-entrypoint.sh"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/richardoc/kube-audit-rest"` |  |
| image.tag | string | `"7c6b957ec970acc705d95a1fac72ea7a15bef9c4-alpine"` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{"fsGroup":255999,"runAsGroup":255999,"runAsUser":255999}` | same as kube audit rest |
| replicaCount | int | `1` | if auto scaling is disabled |
| resources.limits.cpu | string | `"1"` |  |
| resources.limits.memory | string | `"32Mi"` |  |
| resources.requests.cpu | string | `"2m"` |  |
| resources.requests.memory | string | `"10Mi"` |  |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | same as kube audit rest |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tls.manual | object | `{"ca.crt":"REPLACE","tls.crt":"REPLACE","tls.key":"REPLACE"}` | if manual enter the base64 encoded tls cert here |
| tls.mode | string | `"default"` | available modes: default, manual (TODO: cert-mgr mode) |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| webhook.additionalRules | list | `[]` | Additional rules in k8s rules spec format |
| webhook.defaultRules | not empty object | `{}` | A whitelist of default rules. Set this to empty if you dont want to use the default whitelist.  Api groups to blacklist:   - authorization.k8s.io   - authentication.k8s.io   - coordination.k8s.io   - events.k8s.io   - "" (core) -> Endpoints, Events  Format for whitelist:   - apiGroup: ""     versions: []     resources: ["*/*"] |
| webhook.matchConditions | string | `nil` | Kubernetes 1.30+ only https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#matching-requests-matchconditions |
| webhook.matchPolicy | string | `"Equivalent"` | possible values: `Exact` or `Equivalent` https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#matching-requests-matchpolicy |
| webhook.namespaceSelector | list | `[]` | https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#matching-requests-namespaceselector |
| webhook.objectSelector | string | `nil` | Limit requests sent to this webhook by apps matching these labels |

