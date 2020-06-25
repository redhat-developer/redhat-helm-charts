{/*
license  parameter must be set to true
*/}}
{{- define "ibm-operator-catalog-enablement.licenseValidate" -}}
  {{ $license := .Values.license }}
  {{- if contains "true" (.Values.license | quote | lower) }}
    {{- true -}}
  {{- end -}}
{{- end -}}
