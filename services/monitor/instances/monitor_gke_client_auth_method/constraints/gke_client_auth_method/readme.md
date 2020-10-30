# gke_client_auth_method

## Background

Kubernetes provides the option to use client certificates for user authentication. However, as there is no way to revoke these certificates when a user leaves an organization or loses their credential, they are not suitable for this purpose.

It is not possible to fully disable client certificate use within a cluster as it is used for component to component authentication.

With any authentication mechanism the ability to revoke credentials if they are compromised or no longer required, is a key control. Kubernetes client certificate authentication does not allow for this due to a lack of support for certificate revocation.

Client certificate or static password authentication is forbidden in GKE clusters.

## Fix

```shell
gcloud container clusters update cluster-name \
  --no-enable-basic-auth
```

## References

- [Leave legacy client authentication methods disabled (default 1.12+)
](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#restrict_authn_methods)
