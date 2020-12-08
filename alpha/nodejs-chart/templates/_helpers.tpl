{{- define "nodejs.name" -}}
{{ default .Release.Name .Values.global.nameOverride }}
{{- end -}}

{{- define "nodejs.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "nodejs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "nodejs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nodejs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "nodejs.imageName" -}}
{{ default (include "nodejs.name" .) .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}
