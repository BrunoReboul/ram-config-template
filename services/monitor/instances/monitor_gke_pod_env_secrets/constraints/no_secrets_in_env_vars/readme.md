# gke_pod_env_secrets no_secret_in_env_vars

## Background

K8s Pods  can use environment variables.
These variables are not secret, and can be accessed in multiple way.
Sensitive information should not be avaible in function source code, but stored securily and accessed when required.

## Fix

Use Kubernetes Secrets to store and retrieve sensitive informations; or use Google Secret Manager to store sensitive information and use code or gcloud tool in your container to acces it.

## References

- [K8s secrets](https://cloud.google.com/kubernetes-engine/docs/concepts/secret)
- [Cloud Secret Manager](https://cloud.google.com/secret-manager/docs)
