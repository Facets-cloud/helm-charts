{{/*
Expand the name of the chart.
*/}}
{{- define "kube-audit-rest.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-audit-rest.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kube-audit-rest.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kube-audit-rest.labels" -}}
helm.sh/chart: {{ include "kube-audit-rest.chart" . }}
{{ include "kube-audit-rest.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kube-audit-rest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kube-audit-rest.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "kube-audit-rest.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kube-audit-rest.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kube-audit-rest.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Hook Resource Install name
*/}}
{{- define "kube-audit-rest.hooks.fullname" -}}
{{-  include "kube-audit-rest.fullname" . | printf "%s-hook" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Post Install helm annotations

@param .weight helm post install hook weight
@param .hooks what helm hooks to implement. default: post-install,post-upgrade
@param .resourcePolicy delete policy for the hook
*/}}
{{- define "kube-audit-rest.hooks.annotations" -}}
helm.sh/hook: {{ .hooks | default "post-install,post-upgrade" | quote }}
helm.sh/hook-delete-policy: {{ .resourcePolicy | default "delete,before-hook-creation,hook-succeeded" | quote }}
helm.sh/hook-weight: {{ .weight | default 0 | quote }}
{{- end -}}


{{/*
Post Install helm annotations

@param .root a reference to `.`, the root context
@param .args custom args to run
*/}}
{{- define "kube-audit-rest.hooks.job.template" -}}
ttlSecondsAfterFinished: 100
backoffLimit: 1
template:
  spec:
    {{- with .root.imagePullSecrets }}
    imagePullSecrets:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    securityContext:
      runAsUser: 1001
      runAsGroup: 1001
      fsGroup: 1001
    serviceAccountName: {{ include "kube-audit-rest.serviceAccountName" .root }}
    volumes:
      - name: scripts
        configMap:
          name: {{ include "kube-audit-rest.hooks.fullname" .root }}
      - name: tmp
        emptyDir:
          sizeLimit: 100Mi
    containers:
    - name: {{ include "kube-audit-rest.hooks.fullname" .root }}
      image: bitnami/kubectl
      {{- with .args }}
      command: ["/bin/sh", "-c"]
      args:
        - {{ . | toYaml }}
      {{- end }}
      volumeMounts:
        - name: scripts
          mountPath: /scripts/
        - name: tmp
          mountPath: "/tmp"
      env:
        - name: DEPLOYMENT_NAME
          value: {{ include "kube-audit-rest.fullname" .root }}
        - name: SECRET_NAME
          value: {{ include "kube-audit-rest.fullname" .root }}
        - name: RELEASE_NAME
          value: {{ include "kube-audit-rest.fullname" .root }}
        - name: RELEASE_NAMESPACE
          value: {{ .root.Release.Namespace }}
        - name: WEBHOOK_NAME
          value: {{ include "kube-audit-rest.fullname" .root }}
      securityContext:
        {{- toYaml .root.Values.securityContext | nindent 8 }}
      resources:
        limits:
          cpu: "1"
          memory: 512Mi
        requests:
          cpu: 2m
          memory: 10Mi
    restartPolicy: Never
{{- end -}}

{{/*
Helper to convert our webhook whitelist into webhook.rules
*/}}
{{- define "kube-audit-rest.webhook.rules" -}}
{{- with .Values.webhook.defaultRules -}}
{{- $operations := .operations -}}
{{- range $i, $val := .whitelist }}
- operations: {{ $operations | default (list "*") | toYaml | nindent 4 }}
  apiGroups: {{ $val.apiGroup | list | toYaml | nindent 4 }}
  apiVersions: {{ $val.versions | default (list "*")  | toYaml | nindent 4 }}
  resources: {{ $val.resources | default (list "*/*") | toYaml | nindent 4 }}
  scope: "*"
{{- end -}}
{{- end -}}
{{- end -}}

