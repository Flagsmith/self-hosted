package holos

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "flagsmith"
	Chart: {
		name:    "flagsmith"
		version: "0.73.1"
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
								imagePullSecrets: [{ name: "flagsmith-quay-pull-secret" }]
            }
            extraEnv: {
                PROMETHEUS_ENABLED: true
            }
        }
        taskProcessor: enabled: true
        taskProcessor: image: {
						imagePullSecrets: [{ name: "flagsmith-quay-pull-secret" }]
        }

        sse: enabled: true
        sse: image: imagePullSecrets: [{ name: "flagsmith-dockerhub-pull-secret" }]

        influxdb2: enabled: false
    }
}
