# gke_allow_node_sa

## Background

Access scopes are the legacy method of specifying permissions for your nodes, and for workloads running on your nodes if the workloads are using application default credentials (ADC). In clusters running Kubernetes versions prior to 1.10, the cluster's default service account was granted a set of default access scopes.

OAuth scope is fordiden on the service account used with GKE nodePools.

## Fix

Use IAM roles and permissions instead of scopes.

[Configuring a custom service account for workloads](https://cloud.google.com/kubernetes-engine/docs/how-to/access-scopes#service_account)

## References

- [Access scopes](https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam)
- [Migrating from legacy access scopes](https://cloud.google.com/kubernetes-engine/docs/how-to/access-scopes)
