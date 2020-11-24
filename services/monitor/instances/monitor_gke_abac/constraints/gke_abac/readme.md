# gke_abac

## Background

Legacy Authorization, also known as Attribute-Based Access Control (ABAC) has been superseded by Role-Based Access Control (RBAC) and is not under active development.

RBAC is the recommended way to manage permissions in Kubernetes.

In Kubernetes, RBAC is used to grant permissions to resources at the cluster and namespace level. RBAC allows you to define roles with rules containing a set of permissions, whilst the legacy authorizer (ABAC) in Kubernetes Engine grants broad, statically defined permissions.

As RBAC provides significant security advantages over ABAC, it is recommended option for access control. Legacy authorization must be disabled for GKE clusters.

## Fix

```shell
gcloud container clusters update cluster-name \
    --no-enable-legacy-authorization
```

## References

- [https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster)
- [Leave ABAC disabled (default for 1.10+)](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#leave_abac_disabled_default_for_110)
