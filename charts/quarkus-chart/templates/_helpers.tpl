{{- define "quarkus.name" -}}
{{ default .Release.Name .Values.global.nameOverride }}
{{- end -}}

{{- define "quarkus.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "quarkus.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: quarkus
{{- end }}

{{- define "quarkus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quarkus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "quarkus.imageName" -}}
{{ default (include "quarkus.name" .) .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}