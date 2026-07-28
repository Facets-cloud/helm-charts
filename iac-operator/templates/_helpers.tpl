{{/*
Expand the name of the chart.
*/}}
{{- define "iac-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "iac-operator.fullname" -}}
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
Namespace the operator, its release pods, and all namespaced resources live in =
the Helm release namespace (`helm install -n <ns>`). Install into a dedicated
namespace with `--create-namespace` (we recommend `iac-operator`); helm creates
it before the pre-install certgen hook runs. The operator creates its release
pods in this same namespace, so everything is co-located (required for ownerRef
GC), and the control-plane must create Release CRs here too.
*/}}
{{- define "iac-operator.namespace" -}}
{{- .Release.Namespace }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iac-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iac-operator.labels" -}}
helm.sh/chart: {{ include "iac-operator.chart" . }}
{{ include "iac-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iac-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iac-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iac-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iac-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}