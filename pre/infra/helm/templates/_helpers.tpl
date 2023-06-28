{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "optty.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "optty.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Service Annotations 
*/}}
{{- define "optty.service.annotations" -}}
{{- if eq "gce" (include "optty.ingress.class" .) -}}
cloud.google.com/neg: '{"ingress": true}'
cloud.google.com/backend-config: '{"ports": {
"{{ .Values.service.targetPort }}":"{{ include "optty.fullname" . }}"
}}'
{{- end }}
{{- with .Values.service.annotations }}
{{- toYaml . }}
{{- end -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "optty.selectorLabels" -}}
app.kubernetes.io/name: {{ include "optty.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
user: {{ .Values.client.name }}
{{- end }}

{{/*
common labels
*/}}
{{- define "optty.labels" -}}
helm.sh/chart: {{ include "optty.chart" . }}
{{ include "optty.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "optty.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "optty.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate host if not provided
*/}}
{{- define "optty.ingress.host" -}}
{{- if .Values.ingress.host }}
{{- .Values.ingress.host }}
{{- else }}
{{- printf "%s.%s" .Release.Name .Values.client.domain  }}
{{- end }}
{{- end }}

{{- define "optty.ingress.class" -}}
{{ default "gce" .Values.ingress.class}}
{{- end }}
{{/*
Ingress annotations
*/}}
{{- define "optty.ingress.annotations" -}}
kubernetes.io/ingress.class: {{ include "optty.ingress.class" . }}
{{- if eq "gce" (include "optty.ingress.class" .) }}
cloud.google.com/backend-config: '{"default": {{ include "optty.fullname" . | quote }} }'
{{- end }} 
external-dns.alpha.kubernetes.io/hostname: {{ include "optty.ingress.host" . }}
networking.gke.io/v1beta1.FrontendConfig: {{ include "optty.fullname" . }}
{{- if .Values.ingress.tls }}
kubernetes.io/ingress.allow-http: "false"
acme.cert-manager.io/http01-edit-in-place: "true" 
cert-manager.io/{{ default "cluster-issuer" .Values.ingress.issuerType }}: {{ .Values.ingress.issuer | default "lets-encrypt-gce" }}
{{- end }}
# {{- if .Values.ingress.linkerd }} 
 # nginx.ingress.kubernetes.io/configuration-snippet: |
#     proxy_set_header l5d-dst-override {{ include "optty.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.service.targetPort }};
#     grpc_set_header l5d-dst-override {{ include "optty.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.service.targetPort }};
# {{- end }}
{{- with .Values.ingress.annotations }}
{{- toYaml . }}
{{- end -}}
{{ include "optty.checkov" . }}
{{- end }}

{{/*
Deployment Annotations
*/}}
{{- define "optty.deployment.annotations" -}}
{{- toYaml .Values.deployment.annotations -}}
{{ include "optty.checkov" . }}
{{- end }}

{{/*
Checkov Annotations
*/}}
{{- define "optty.checkov" -}}
{{- range $index, $id := .Values.checkovSkippedIDs}}
checkov.io/skip{{ add $index 1 }}: {{$id}}
{{- end }}
{{- end }}