{{/*
Expand the name of the chart.
*/}}
{{- define "wildfly-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "wildfly-common.fullName" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
wildfly-common.appImageName is the name of the application image that is built/deployed
*/}}
{{- define "wildfly-common.appImageName" -}}
{{ default (include "wildfly-common.appName" .) .Values.image.name }}
{{- end -}}

{{/*
wildfly-common.appImage is the name:tag of the application image of of the application image that is built/deployed
*/}}
{{- define "wildfly-common.appImage" -}}
{{ include "wildfly-common.appImageName" . }}:{{ .Values.image.tag}}
{{- end -}}

{{/*
wildfly.appBuilderImageName corresponds to the name of the application Builder image
*/}}
{{- define "wildfly-common.appBuilderImageName" -}}
{{ include "wildfly-common.appImageName" . }}-build-artifacts
{{- end }}

{{/*
wildfly.appBuilderImage is the name:tag of the application Builder image
*/}}
{{- define "wildfly-common.appBuilderImage" -}}
{{ include "wildfly-common.appBuilderImageName" . }}:{{ .Values.image.tag}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wildfly-common.appName" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wildfly-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wildfly-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Trigger a build from GitHub Webhook
*/}}
{{- define "wildfly-common.buildconfig.triggers.github" -}}
{{- if .Values.build.triggers.githubSecret}}
{{- if lookup "v1" "Secret" .Release.Namespace .Values.build.triggers.githubSecret }}
- type: "GitHub"
  github:
    secretReference:
      name: {{ quote .Values.build.triggers.githubSecret }}
{{ else }}
{{ fail (printf "Secret '%s' for GitHub webhook does not exist." .Values.build.triggers.githubSecret) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Trigger a build from Generic Webhook
*/}}
{{- define "wildfly-common.buildconfig.triggers.generic" -}}
{{- if .Values.build.triggers.genericSecret}}
{{- if lookup "v1" "Secret" .Release.Namespace .Values.build.triggers.genericSecret }}
- type: "Generic"
  generic:
    secretReference:
      name: {{ quote .Values.build.triggers.genericSecret }}
    allowEnv: true
{{ else }}
{{ fail (printf "Secret '%s' for Generic webhook does not exist." .Values.build.triggers.genericSecret) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Image pull secret to build the application image
*/}}
{{- define "wildfly-common.buildconfig.pullSecret" -}}
{{- if .Values.build.pullSecret}}
{{- if lookup "v1" "Secret" .Release.Namespace .Values.build.pullSecret }}
pullSecret:
  name: {{ .Values.build.pullSecret }}
{{ else }}
{{ fail (printf "Secret '%s' to pull images does not exist." .Values.build.pullSecret) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Image push secret to push the application image
*/}}
{{- define "wildfly-common.buildconfig.pushSecret" -}}
{{- if and .Values.build.output.pushSecret (eq .Values.build.output.kind "DockerImage") -}}
{{- if lookup "v1" "Secret" .Release.Namespace .Values.build.output.pushSecret -}}
pushSecret:
  name: {{ .Values.build.output.pushSecret }}
{{- else }}
{{- fail (printf "Secret '%s' to push the application image does not exist." .Values.build.output.pushSecret) }}
{{- end }}
{{- end }}
{{- end }}