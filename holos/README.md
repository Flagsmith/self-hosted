# Deploying Flagsmith with Holos

This is a definition of a Flagsmith deployment written using [Holos](https://holos.run/) as a learning exercise.

The files inside [`deploy`](/deploy) are the resulting Kubernetes resources generated when
running `holos render platform`. This is effectively a [rendered manifest](https://akuity.io/blog/the-rendered-manifests-pattern)
of a Flagsmith deployment that can be directly applied to a cluster, either manually or
with a GitOps pipeline.

The rendered Kubernetes resource files are meant to be committed to this repository. They
let us know the exact impact of any configuration changes or Helm chart updates.

The default Helm values are [manually imported](https://holos.run/docs/v1alpha5/tutorial/helm-values/#importing-helm-values)
into the repository as CUE files. This lets us build complex configuration across multiple Helm charts, clusters,
environments, etc while being able to track the exact state of all resources in an immutable rendered manifest.

To apply this platform to your cluster, run `scripts/apply`. This does a `kubectl apply -f` for all the files in the
`deploy` directory, but in a specific order so that the cluster can be bootstrapped from an empty state (e.g. namespaces
are created first, which are typically not created by individual Helm charts).

For a more complex example that deploys a real-world-like software platform, including separate management/workload
clusters and GitOps CD, see [Bank of Holos](https://github.com/holos-run/bank-of-holos).
