{{- define "selector.template" -}}
selector:
    matchLabels:
      app: {{ .Values.appName.app }}-dpl
{{- end }}

{{- define "affinity.template" }}
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node-type
          operator: In
          values:
          - master
{{- end}}