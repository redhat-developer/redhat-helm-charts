{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "infinispan-helm-charts.name" -}}
{{- default .Release.Name .Values.deploy.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "infinispan-helm-charts.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generated Secret Name
*/}}
{{- define "infinispan-helm-charts.secret" -}}
{{- if eq (.Values.deploy.security.secretName) "" }}
{{- printf "%s-generated-secret" (include "infinispan-helm-charts.name" .) }}
{{- else }}
{{- .Values.deploy.security.secretName }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "infinispan-helm-charts.labels" -}}
clusterName: {{ include "infinispan-helm-charts.name" . }}
helm.sh/chart: {{ include "infinispan-helm-charts.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- range .Values.deploy.resourceLabels }}
{{ .key }}: {{ .value }}
{{- end }}
{{- end }}

{{/*
Service selector labels
*/}}
{{- define "infinispan-helm-charts.selectorLabels" -}}
clusterName: {{ include "infinispan-helm-charts.name" . }}
app: infinispan-pod
{{- end }}
