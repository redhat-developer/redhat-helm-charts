{{- define "dotnet.name" -}}
{{ default .Release.Name .Values.global.nameOverride }}
{{- end -}}

{{- define "dotnet.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "dotnet.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: dotnet
{{- end }}

{{- define "dotnet.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dotnet.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "dotnet.imageName" -}}
{{ default (include "dotnet.name" .) .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}