{{- define "dnsfilter-relay.listenAddresses" -}}
{{- $values := list -}}
{{- range .Values.config.listenAddresses -}}
    {{- $values = . | quote | append $values -}}
{{- end -}}
{{ join ", " $values }}
{{- end -}}

{{- define "dnsfilter-relay.upstreamOrder" -}}
{{- $values := list -}}
{{- range .Values.config.upstreamOrder -}}
    {{- $values = . | quote | append $values -}}
{{- end -}}
{{ join ", " $values }}
{{- end -}}

{{- define "dnsfilter-relay.localDnsServers" }}
{{- $values := list -}}
{{- range .Values.config.localDnsServers }}
[[local_dns_server]]
    {{- $localvalues := list -}}
    {{- $localvalues = . -}}
    {{- range $localvalues.addresses -}}
        {{- $values = . | quote | append $values -}}
    {{- end }}
addresses = [ {{ join ", " $values }} ]
    {{- $values = list -}}
    {{- range $localvalues.localDomains -}}
        {{- $values = . | quote | append $values -}}
    {{- end }}
local_domains = [ {{ join ", " $values }} ]
    {{ $values = list -}}
{{- end -}}
{{- end -}}

{{- define "dnsfilter-relay.upstreamServers" }}
{{- $values := list -}}
{{- range .Values.config.upstreamServers -}}
{{- $values = . }}
[[upstream_server]]
ip_address = "{{- $values.ipAddress -}}"
port = {{ $values.port }}
tcp_reuse = "{{- $values.tcpReuse -}}"
rw_timeout = "{{- $values.rwTimeout -}}"
{{- end -}}
{{- end -}}

{{- define "dnsfilter-relay.tcpUpstreamServers" }}
{{- $values := list -}}
{{- range .Values.config.tcpUpstreamServers -}}
{{- $values = . }}
[[tls_upstream_server]]
auth_name = "{{- $values.authName -}}"
ip_address = "{{- $values.ipAddress -}}"
port = {{ $values.port }}
tcp_reuse = "{{- $values.tcpReuse -}}"
rw_timeout = "{{- $values.rwTimeout -}}"

{{ end -}}
{{- end -}}


{{- define "dnsfilter-relay.config" -}}
listen_addresses = [ {{ include "dnsfilter-relay.listenAddresses" . }} ]
so_reuse_port = {{- .Values.config.soReusePort -}}
upstream_order = [ {{ include "dnsfilter-relay.upstreamOrder" . }} ]
ping_upstream_servers = {{- .Values.config.pingUpstreamServers -}}
ping_upstream_servers_interval = {{- .Values.config.pingUpstreamServersInterval -}}
randomize_upstream_servers = {{- .Values.config.randomizeUpstreamServers -}}
gdpr_support = {{- .Values.config.gdprSupport -}}
persistent_tls_connection = {{- .Values.config.persistentTlsConnection -}}

[log]
level = "{{- .Values.config.log.level -}}"
format = "{{- .Values.config.log.format -}}"

[client]
name = {{ required "A valid .Values.config.client.name entry required!" .Values.config.client.name }}
secretKey = {{ required "A valid .Values.config.client.secretKey entry required!" .Values.config.client.secretKey }}

[client.registration_override_dns]
enabled = {{- .Values.config.client.registrationOverrideDns.enabled -}}
#address = "1.1.1.1:53"
address = "{{- .Values.config.client.registrationOverrideDns.address -}}"
protocol = "{{- .Values.config.client.registrationOverrideDns.protocol -}}"
timeout = {{- .Values.config.client.registrationOverrideDns.timeout }}

{{ include "dnsfilter-relay.localDnsServers" . }}

{{ include "dnsfilter-relay.upstreamServers" . }}

{{ include "dnsfilter-relay.tcpUpstreamServers" . }}

{{ end }}