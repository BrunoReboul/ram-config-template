# gke_disable_default_sa

## Background

Each GKE node has an Identity and Access Management (IAM) Service Account associated with it. By default, nodes are given the Compute Engine default service account, which you can find by navigating to the IAM section of the Cloud Console. This account has broad access by default, making it useful to wide variety of applications, but it has more permissions than are required to run your Kubernetes Engine cluster. You should create and use a minimally privileged service account to run your GKE cluster instead of using the Compute Engine default service account.

GKE Clusters' Nodes with default compute engine service account are forbidden.

## Fix

```shell
gcloud iam service-accounts create sa-name \
  --display-name=sa-name

gcloud projects add-iam-policy-binding project-id \
  --member "serviceAccount:sa-name@project-id.iam.gserviceaccount.com" \
  --role roles/logging.logWriter

gcloud projects add-iam-policy-binding project-id \
  --member "serviceAccount:sa-name@project-id.iam.gserviceaccount.com" \
  --role roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding project-id \
  --member "serviceAccount:sa-name@project-id.iam.gserviceaccount.com" \
  --role roles/monitoring.viewer
```

## References

- [Prefer not running GKE clusters using the Compute Engine default service account](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#use_least_privilege_sa)
