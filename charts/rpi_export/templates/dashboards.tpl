{{- if .Values.dashboards.enabled }}
{{- $root := . }}
{{- range $path, $bytes := .Files.Glob "dashboards/**.json" }}
{{- $filename := trimPrefix "dashboards/" $path }}
{{- $name :=  trimSuffix ".json" $filename }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%s-%s" $name (include "rpi-export.fullname" $root) | trunc 63 | trimSuffix "-" }}
  labels:
    {{- include "rpi-export.labels" $root | nindent 4 }}
  {{- with $root.Values.dashboards.labels }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
data:
  {{ $filename -}}: |-
  {{- $bytes | toString | nindent 4 }}
---
{{- end }}
{{- end }}
