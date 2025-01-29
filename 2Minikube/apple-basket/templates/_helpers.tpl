{{/*
Expand the name of the chart.
*/}}
{{- define "apple-basket.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "apple-basket.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "apple-basket.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "apple-basket.labels" -}}
helm.sh/chart: {{ include "apple-basket.chart" . }}
{{ include "apple-basket.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "apple-basket.selectorLabels" -}}
app.kubernetes.io/name: {{ include "apple-basket.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "apple-basket.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "apple-basket.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "apple-basket.fullname" -}}
{{ .Release.Name }}
{{- end }}

{{- define "apple-basket.labels" -}}
app: {{ include "apple-basket.fullname" . }}
{{- end }}

{{- define "apple-basket.mongodb.fullname" -}}
{{ .Release.Name }}-mongodb
{{- end }}

{{- define "apple-basket.mongodb.labels" -}}
app: {{ include "apple-basket.mongodb.fullname" . }}
{{- end }}
