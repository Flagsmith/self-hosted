# Self-hosted Flagsmith example

This example deploys Flagsmith to Kubernetes. It also deploys
[kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) with
Grafana for monitoring.

Flagsmith API and task processor pods are scraped using a [`ServiceMonitor`](https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.ServiceMonitor).

> [!WARNING]
> This example and all its resources (e.g. dashboards) are provided as reference examples with no stability or
> backwards compatibility guarantees.

## Usage

```
helmfile sync
```

Grafana dashboards are available at http://prometheus-grafana.monitoring.svc.cluster.local/.

## Dashboard example

![dashboard.png](dashboard.png)
