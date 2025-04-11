# Self-hosted Flagsmith example

This example deploys Flagsmith using kube-prometheus with Grafana for monitoring.

Flagsmith API and task processor pods are scraped using a [`ServiceMonitor`](https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.ServiceMonitor).

## Usage

```
helmfile sync
```

Grafana dashboards are available at http://prometheus-grafana.monitoring.svc.cluster.local/.
