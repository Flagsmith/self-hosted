package holos

Helm: Values: {
	common: {
		// Labels to add to all the resources deployed by this chart
		labels: {}
		// Annotations to add to all the resources deployed by this chart
		annotations: {}
	}
	api: {
		image: {
			repository:      string | *"flagsmith.docker.scarf.sh/flagsmith/flagsmith-api"
			tag:             string // defaults to .Chart.AppVersion
			imagePullPolicy: "IfNotPresent"
			imagePullSecrets: []
		}
		// Note that if setting this to false, need to set
		// api.image.repository to flagsmith/flagsmith (or some other
		// repository hosting the image with combined frontend and backend)
		// and that the image tag exists (for flagsmith/flagsmith, >=2.10.0)
		//
		// Also, note that the ingress and service for the frontend remain
		// (unless explicitly switched off), but both are handled by the api
		// deployment's pods.
		separateApiAndFrontend: true
		replicacount:           1
		deploymentStrategy:     null
		podAnnotations: {}
		resources: {}
		// limits:
		//   cpu: 500m
		//   memory: 500Mi
		// requests:
		//   cpu: 300m
		//   memory: 300Mi
		podLabels: {}
		// https://docs.flagsmith.com/deployment/hosting/locally-api#environment-variables
		extraEnv: {
			// Allows authenticating with a local password to Django Admin
			// See https://docs.flagsmith.com/deployment/configuration/django-admin
			ENABLE_ADMIN_ACCESS_USER_PASS: true
		}
		// extraEnvFromSecret:
		//   NAME:
		//    secretName: mysecret
		//    secretKey: mykey
		extraEnvFromSecret: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
		podSecurityContext: {}
		defaultPodSecurityContext: {
			// runAsNonRoot: true  # TODO: enable this, conditional on tag semver
			// runAsUser: 1000
			// runAsGroup: 1000
			enabled: true
		}
		livenessProbe: {
			path:                "/health/liveness"
			failureThreshold:    5
			initialDelaySeconds: 5
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		readinessProbe: {
			path:                "/health/readiness"
			failureThreshold:    10
			initialDelaySeconds: 1
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		statsd: {
			enabled:        false
			host:           null
			hostFromNodeIp: false
			port:           8125
			prefix:         "flagsmith.api"
		}
		influxdbSetup: enabled: false
		extraInitContainers: []
		extraContainers: []
		extraVolumes: []
		volumeMounts: []
		logging: format: "generic" // options are generic or json.
		enableMigrateDbInitContainer: true
		bootstrap: {
			// Set to `true` to create initial superuser, organisation, and project.
			// If `adminEmail`, `organisationName` or `projectName` not set, defaults are used.
			// Bootstrapping does nothing if app database is not empty.
			enabled:          false
			adminEmail:       null
			organisationName: null
			projectName:      null
			extraSpec: {// Will be added to `spec` for `flagsmith-api` deployment.
			}
		}

		// secretKeyFromExistingSecret points to the Secret that contains the Django secret key. If none is provided, a Job
		// will be created to generate one.
		// See https://docs.djangoproject.com/en/4.2/topics/signing/
		secretKeyFromExistingSecret: {
			enabled: false
			name:    ""
			key:     ""
		}
	}
	frontend: {
		// Set this to `false` to switch off the frontend (deployment,
		// service and ingress). Set api.separateApiAndFrontend to false to
		// switch off the deployment but retain the service and ingress
		// pointing at the single Docker image that serves both.
		enabled: true
		image: {
			repository:      "flagsmith.docker.scarf.sh/flagsmith/flagsmith-frontend"
			tag:             null // defaults to .Chart.AppVersion
			imagePullPolicy: "IfNotPresent"
			imagePullSecrets: []
		}
		replicacount:       1
		deploymentStrategy: null
		resources: {}
		// limits:
		//   cpu: 500m
		//   memory: 500Mi
		// requests:
		//   cpu: 300m
		//   memory: 300Mi
		apiProxy: {
			enabled: true
		}
		extraEnv: {}
		extraEnvFromSecret: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
		podSecurityContext: {}
		defaultPodSecurityContext: {
			// runAsNonRoot: true  # TODO: enable this, conditional on tag semver
			// runAsUser: 1000
			// runAsGroup: 1000
			enabled: true
		}
		livenessProbe: {
			failureThreshold:    20
			initialDelaySeconds: 20
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      10
		}
		readinessProbe: {
			failureThreshold:    20
			initialDelaySeconds: 20
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      10
		}
		extraInitContainers: []
		extraContainers: []
		extraVolumes: []
		volumeMounts: []
		extraSpec: {// Will be added to `spec` for `flagsmith-frontend` deployment.
		}
	}

	// See https://docs.flagsmith.com/deployment/task-processor
	taskProcessor: {
		image: {
			// all values here default to those in .Values.api.image if not configured
			// this is to simplify the logic for those using flagsmith-api image
			// and to maintain backwards compatibility.
			repository:       null
			tag:              null
			imagePullPolicy:  null
			imagePullSecrets: null
		}
		enabled:         bool | false
		replicacount:    1
		sleepIntervalMs: null
		numThreads:      null
		gracePeriodMs:   null
		queuePopSize:    null
		livenessProbe: {
			failureThreshold:    5
			initialDelaySeconds: 5
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      30
		}
		readinessProbe: {
			failureThreshold:    10
			initialDelaySeconds: 1
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      30
		}
		podAnnotations: {}
		resources: {}
		// limits:
		//   cpu: 500m
		//   memory: 500Mi
		// requests:
		//   cpu: 300m
		//   memory: 300Mi
		podLabels: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
		podSecurityContext: {}
		defaultPodSecurityContext: {
			// runAsNonRoot: true  # TODO: enable this, conditional on tag semver
			// runAsUser: 1000
			// runAsGroup: 1000
			enabled: true
		}
		extraInitContainers: []
		extraContainers: []
		extraEnv: {}
		extraVolumes: []
		volumeMounts: []
		extraSpec: {// Will be added to `spec` for `flagsmith-task-processor` deployment.
		}
	}
	devPostgresql: {
		enabled: true
		serviceAccount: create: true
		nameOverride: "dev-postgresql"
		auth: {
			postgresPassword: "flagsmith"
			database:         "flagsmith"
		}
	}
	databaseExternal: {
		enabled:  false
		url:      null
		type:     "postgres"
		host:     null
		port:     5432
		database: null
		username: null
		password: null
		urlFromExistingSecret: {
			enabled: false
			name:    null
			key:     null
		}
	}
	pgbouncer: {
		enabled: false
		image: {
			repository:      "bitnami/pgbouncer"
			tag:             "1.16.0"
			imagePullPolicy: "IfNotPresent"
			imagePullSecrets: []
		}
		replicaCount:       1
		deploymentStrategy: null
		// Optional: Use to override the password directly instead of extracting from the database URL
		passwordOverride: ""
		podAnnotations: {}
		resources: {}
		podLabels: {}
		extraEnv: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
		podSecurityContext: {}
		defaultPodSecurityContext: {
			// runAsNonRoot: true
			enabled: true
		}
		securityContext: {}
		defaultSecurityContext: {
			enabled:                  true
			allowPrivilegeEscalation: false
			capabilities: drop: ["all"]
		}
		livenessProbe: {
			failureThreshold:    5
			initialDelaySeconds: 5
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		readinessProbe: {
			failureThreshold:    10
			initialDelaySeconds: 1
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		extraInitContainers: []
		extraContainers: []
		extraVolumes: []
		volumeMounts: []
	}
	influxdb2: {
		enabled: bool | true
		adminUser: {
			organization:     "influxdata"
			bucket:           "default"
			user:             "admin"
			retention_policy: "0s"
			//# Leave empty to generate a random password and token.
			//# Or fill any of these values to use fixed values.
			password: ""
			token:    ""
			//# The password and token are obtained from an existing secret. The expected
			//# keys are `admin-password` and `admin-token`.
			//# If set, the password and token values above are ignored.
			existingSecret: null
		}
		persistence: {
			// storageClass: "-"
			// accessMode: ReadWriteOnce
			// size: 50Gi
			enabled: false
		}
		resources: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
	}
	influxdbExternal: {
		enabled:      false
		url:          null
		bucket:       null
		organization: null
		token:        null
		tokenFromExistingSecret: {
			enabled: false
			name:    null
			key:     null
		}
	}
	UsePostgresForAnalytics: enabled: false

	// This is included primarily for easy testing of statsd integration from the application.
	graphite: {
		enabled:                 false
		nameOverride:            "flagsmith-graphite"
		autoSetStatsdHostEnvVar: true
	}
	sse: {
		enabled: bool | false
		// See all supported environment variables here:
		// https://docs.flagsmith.com/deployment/hosting/real-time/deployment#sse-service
		// extraEnv:
		//   REDIS_HOST: redis.example.com
		//   REDIS_PORT: 6379
		//   USE_CLUSTER_MODE: true # - set this if connecting to a Redis cluster, not a single node
		// extraEnvFromSecret:
		//   REDIS_PASSWORD:
		//    secretName: my_redis_secrets
		//    secretKey: my_redis_password
		image: {
			repository:      "flagsmith/sse"
			tag:             "3.6.0"
			imagePullPolicy: "IfNotPresent"
			imagePullSecrets: []
		}

		// authenticationTokenFromExistingSecret is a shared secret between the API and SSE service. If none is provided, a Job
		// will be created to generate one.
		authenticationTokenFromExistingSecret: {
			enabled: false
			name:    ""
			key:     ""
		}
		replicaCount:       1
		deploymentStrategy: null
		podAnnotations: {}
		resources: {}
		// limits:
		//   cpu: 500m
		//   memory: 500Mi
		// requests:
		//   cpu: 300m
		//   memory: 300Mi
		podLabels: {}
		nodeSelector: {}
		tolerations: []
		affinity: {}
		podSecurityContext: {}
		defaultPodSecurityContext: {
			// runAsNonRoot: true  # TODO: enable this, conditional on tag semver
			// runAsUser: 1000
			// runAsGroup: 1000
			enabled: true
		}
		livenessProbe: {
			path:                "/health/liveness"
			failureThreshold:    5
			initialDelaySeconds: 5
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		readinessProbe: {
			path:                "/health/readiness"
			failureThreshold:    10
			initialDelaySeconds: 1
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      2
		}
		shareProcessNamespace: false
		serviceAccountName:    null
		extraInitContainers: []
		extraContainers: []
		extraVolumes: []
		volumeMounts: []
	}
	service: {
		api: {
			type: "ClusterIP"
			port: 8000
			annotations: {}
		}
		frontend: {
			type: "ClusterIP"
			port: 8080
			annotations: {}
		}
		sse: {
			type: "ClusterIP"
			port: 8000
			annotations: {}
		}
		taskProcessor: {
			type: "ClusterIP"
			port: 8000
			annotations: {}
		}
	}
	hpa: api: {
		enabled:              false
		minReplicas:          2
		maxReplicas:          10
		targetCPUUtilization: 50
	}
	ingress: {
		frontend: {
			enabled: false
			annotations: {}
			ingressClassName: null
			// kubernetes.io/ingress.class: nginx
			// kubernetes.io/tls-acme: "true"
			hosts: ["chart-example.local"]
			//  - secretName: chart-example-tls
			//    hosts:
			//      - chart-example.local
			tls: []
		}
		api: {
			enabled: false
			annotations: {}
			ingressClassName: null
			// kubernetes.io/ingress.class: nginx
			// kubernetes.io/tls-acme: "true"
			hosts: [{
				host: "chart-example.local"
				paths: []
			}]
			//  - secretName: chart-example-tls
			//    hosts:
			//      - chart-example.local
			tls: []
		}
		sse: {
			enabled: false
			annotations: {}
			ingressClassName: null
			// kubernetes.io/ingress.class: nginx
			// kubernetes.io/tls-acme: "true"
			hosts: [{
				host: "chart-example.local"
				paths: []
			}]
			//  - secretName: chart-example-tls
			//    hosts:
			//      - chart-example.local
			tls: []
		}
	}
	jobs: {
		migrateDb: {
			enabled:                 false
			ttlSecondsAfterFinished: 3600
			restartPolicy:           "OnFailure"
			defaultPodSecurityContext: {
				// runAsNonRoot: true
				enabled: true
			}
			extraContainers: []
			extraVolumes: []
			command: []
			args: []
		}
		migrateAnalyticsData: {
			enabled: false
			args: []
			extraContainers: []
			extraVolumes: []
		}
	}

	// These tests just make non-destructive requests to the services in
	// the cluster. Enabling this and running helm test is safe.
	tests: {
		// A test is enabled if both this and the specific test is enabled
		enabled: false
		api: {
			enabled:           true
			maxTime:           10
			printResponseBody: false
		}
		frontend: {
			enabled:           true
			maxTime:           10
			printResponseBody: false
		}
	}

	// These are used for integration testing the chart and the
	// application. Enabling this will mean that data in a release is
	// destroyed or corrupted if the tests are run.
	"_destructiveTests": {
		// A test is enabled if both this and the specific test is enabled
		enabled:   false
		testToken: "test-e2e-token"
		e2e: {
			enabled: true
			image: {
				repository:      "flagsmith/flagsmith-e2e-tests"
				tag:             null
				imagePullPolicy: "IfNotPresent"
			}
			resources: requests: memory: "1Gi"
		}
	}

	// -- Array of extra K8s manifests to deploy
	//# Note: Supports use of custom Helm templates
	//# Example: Deploying a CloudnativePG Postgres cluster for use with Flagmsith:
	// - |
	//   apiVersion: postgresql.cnpg.io/v1
	//   kind: Cluster
	//   metadata:
	//     name: flagsmith
	//     namespace: {{ .Release.Namespace }}
	//   spec:
	//     instances: 3
	//     storage:
	//       size: 10Gi
	extraObjects: []
}
