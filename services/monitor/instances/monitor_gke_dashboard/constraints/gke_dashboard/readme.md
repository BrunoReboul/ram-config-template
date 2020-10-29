# gke_dashboard

## Background

The Kubernetes Web UI (Dashboard) has been a historical source of vulnerability.

You should disable the Kubernetes Web UI (Dashboard) when running on Kubernetes Engine. The Kubernetes Web UI is backed by a highly privileged Kubernetes Service Account.

The Google Cloud Console provides all the required functionality of the Kubernetes Web UI and leverages Cloud IAM to restrict user access to sensitive cluster controls and settings.

GKE Dashboard must be disabled.

## Fix

```shell
gcloud container clusters update cluster-name \
    --update-addons=KubernetesDashboard=DISABLED
```

## References

- [Leave the Kubernetes web UI (Dashboard) disabled (default for 1.10+)](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#disable_kubernetes_dashboard)
