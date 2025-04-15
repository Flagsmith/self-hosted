package holos

holos: Helm.BuildPlan

Helm: #Helm & {
	Chart: {
		name:    "flagsmith"
		version: "0.73.0"
		repository: {
			name: "flagsmith"
			url:  "https://flagsmith.github.io/flagsmith-charts/"
		}
	}
    EnableHooks: true
    Values: {
        api: {
            image: {
                repository: "quay.io/flagsmithofficial/flagsmith-enterprise-api"
                tag: "2.171.0"
            }
            extraEnv: {
                PROMETHEUS_ENABLED: true
            }
        }
        taskProcessor: enabled: true
        sse: enabled: true
        influxdb2: enabled: false
    }
}
