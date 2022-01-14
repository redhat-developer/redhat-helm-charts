{{- define "vertx.name" -}}
{{ default .Release.Name .Values.global.nameOverride }}
{{- end -}}

{{- define "vertx.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "vertx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: vertx
{{- end }}

{{- define "vertx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vertx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "vertx.imageName" -}}
{{ default (include "vertx.name" .) .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}