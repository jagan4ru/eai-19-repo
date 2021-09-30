{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "eric-sec-sip-tls-crd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eric-sec-sip-tls-crd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart version as used by the version label.
*/}}
{{- define "eric-sec-sip-tls-crd.version" -}}
{{- printf "%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create image registry url
*/}}
{{- define "eric-sec-sip-tls-crd.registryUrl" -}}
    {{- $registryUrl := "armdocker.rnd.ericsson.se" -}}
    {{- if .Values.global -}}
        {{- if .Values.global.registry -}}
            {{- if .Values.global.registry.url -}}
                {{- $registryUrl = .Values.global.registry.url -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{- if .Values.imageCredentials.registry -}}
        {{- if .Values.imageCredentials.registry.url -}}
            {{- $registryUrl = .Values.imageCredentials.registry.url -}}
        {{- end -}}
    {{- end -}}
    {{- print $registryUrl -}}
{{- end -}}

{{/*
Create image registry url and repo path
*/}}
{{- define "eric-sec-sip-tls-crd.registryUrlPath" -}}
{{- include "eric-sec-sip-tls-crd.registryUrl" . }}/{{ .Values.imageCredentials.repoPath }}
{{- end -}}

{{/*
Create image pull secrets
*/}}
{{- define "eric-sec-sip-tls-crd.pullSecrets" -}}
    {{- $globalPullSecret := "" -}}
    {{- if .Values.global -}}
        {{- if .Values.global.pullSecret -}}
            {{- $globalPullSecret = .Values.global.pullSecret -}}
        {{- end -}}
    {{- end -}}
    {{- if .Values.imageCredentials -}}
        {{- if .Values.imageCredentials.pullSecret -}}
             {{- $globalPullSecret = .Values.imageCredentials.pullSecret -}}
        {{- end -}}
    {{- end -}}
    {{- print $globalPullSecret -}}
{{- end -}}

{{/*
Create image pull policy
*/}}
{{- define "eric-sec-sip-tls-crd.imagePullPolicy" -}}
    {{- $globalRegistryImagePullPolicy := "IfNotPresent" -}}
    {{- if .Values.global -}}
        {{- if .Values.global.registry -}}
            {{- if .Values.global.registry.imagePullPolicy -}}
                {{- $globalRegistryImagePullPolicy = .Values.global.registry.imagePullPolicy -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{- if .Values.imageCredentials -}}
        {{- if .Values.imageCredentials.registry -}}
            {{- if .Values.imageCredentials.registry.imagePullPolicy -}}
                {{- $globalRegistryImagePullPolicy = .Values.imageCredentials.registry.imagePullPolicy -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{- print $globalRegistryImagePullPolicy -}}
{{- end -}}

{{/*
Create the fsGroup value according to DR-D1123-123.
*/}}
{{- define "eric-sec-sip-tls-crd.fsGroup.coordinated" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.fsGroup -}}
      {{- if .Values.global.fsGroup.manual -}}
        {{ .Values.global.fsGroup.manual }}
      {{- else -}}
        {{- if eq .Values.global.fsGroup.namespace true -}}
          # The 'default' defined in the Security Policy will be used.
        {{- else -}}
          10000
        {{- end -}}
      {{- end -}}
    {{- else -}}
      10000
    {{- end -}}
  {{- else -}}
    10000
  {{- end -}}
{{- end -}}

{{/*
Define the role reference for security-policy
*/}}
{{- define "eric-sec-sip-tls-crd.securityPolicy.reference" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.security -}}
      {{- if .Values.global.security.policyReferenceMap -}}
        {{ $mapped := index .Values "global" "security" "policyReferenceMap" "default-restricted-security-policy" }}
        {{- if $mapped -}}
          {{ $mapped }}
        {{- else -}}
          default-restricted-security-policy
        {{- end -}}
      {{- else -}}
        default-restricted-security-policy
      {{- end -}}
    {{- else -}}
      default-restricted-security-policy
    {{- end -}}
  {{- else -}}
    default-restricted-security-policy
  {{- end -}}
{{- end -}}

{{/*
Define the annotations for security-policy
*/}}
{{- define "eric-sec-sip-tls-crd.securityPolicy.annotations" -}}
ericsson.com/security-policy.name: "restricted/default"
ericsson.com/security-policy.privileged: "false"
ericsson.com/security-policy.capabilities: "N/A"
{{- end -}}