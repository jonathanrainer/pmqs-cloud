{{- define "application_config_configmap_name" }}{{.Chart.Name}}-{{.Values.applicationConfig.configMapName}}{{- end }}
{{- define "log_config_configmap_name" }}{{.Chart.Name}}-{{.Values.logConfig.configMapName}}{{- end }}
{{- define "log_config_file_path" }}{{.Values.logConfig.configFolder}}/{{.Values.logConfig.configFileName}}{{- end }}
