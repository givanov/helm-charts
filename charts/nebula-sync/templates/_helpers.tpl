{{/*
Expand the name of the chart.
*/}}
{{- define "nebula-sync.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nebula-sync.fullname" -}}
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
Create chart name and version as used for the chart label.
*/}}
{{- define "nebula-sync.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nebula-sync.labels" -}}
helm.sh/chart: {{ include "nebula-sync.chart" . }}
{{ include "nebula-sync.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nebula-sync.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nebula-sync.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nebula-sync.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nebula-sync.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render the env vars for one webhook (SUCCESS or FAILURE).
Expects .Prefix (e.g. "WEBHOOK_SYNC_SUCCESS") and .Cfg with url, method,
body and headers (map). Emits YAML list items, indented by the caller.
*/}}
{{- define "nebula-sync.webhookEnv" -}}
{{- if .Cfg.url }}
- name: {{ .Prefix }}_URL
  value: {{ .Cfg.url | quote }}
{{- end }}
{{- if .Cfg.method }}
- name: {{ .Prefix }}_METHOD
  value: {{ .Cfg.method | quote }}
{{- end }}
{{- if .Cfg.body }}
- name: {{ .Prefix }}_BODY
  value: {{ .Cfg.body | quote }}
{{- end }}
{{- range $k, $v := .Cfg.headers }}
- name: {{ $.Prefix }}_HEADERS_{{ $k | upper }}
  value: {{ $v | quote }}
{{- end }}
{{- end }}
