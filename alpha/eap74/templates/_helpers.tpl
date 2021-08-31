
{{/*
eap74.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdkVersion.

TODO: the build.s2i.arch is not used and is hard-coded to "amd64".
When we add support for Z-Series and PowerPC, we will rely on the value of build.s2i.arch
to get the proper S2I images (and validate that only jdk11 can be used with Z & P)
*/}}
{{- define "eap74.eapBuilderImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{ .Values.build.s2i.amd64.jdk8.builderImage}}:{{ include "eap74.version" . }}
{{- else -}}
{{ .Values.build.s2i.amd64.jdk11.builderImage}}:{{ include "eap74.version" . }}
{{- end -}}
{{- end -}}

{{/*
eap74.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap74.eapRuntimeImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{ .Values.build.s2i.amd64.jdk8.runtimeImage}}:{{ include "eap74.version" . }}
{{- else -}}
{{ .Values.build.s2i.amd64.jdk11.runtimeImage}}:{{ include "eap74.version" . }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap74.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
If build.s2i.version is not defined, use by defaul the Chart's appVersion
*/}}
{{- define "eap74.version" -}}
{{- default .Chart.AppVersion .Values.build.s2i.version -}}
{{- end -}}


{{- define "eap74.labels" -}}
helm.sh/chart: {{ include "eap74.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap
{{- end }}

{{- define "eap74.metering.labels" -}}
com.company: "Red_Hat"
com.redhat.product-name: "Red_Hat_Runtimes"
com.redhat.product-version: "2021-Q2"
com.redhat.component-name: EAP
com.redhat.component-version: {{ quote .Chart.AppVersion }}
com.redhat.component-type: application
{{- end }}

{{- define "eap74.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap74.labels" . | nindent 4 }}
  {{- include "eap74.metering.labels" . | nindent 4 }}
{{- end -}}