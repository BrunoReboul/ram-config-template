# gke_version

## Background

Keeping the version of Kubernetes up to date is one of the simplest things you can do to improve your security.

Only up-to-date version are allowed.

## Fix

```shell
gcloud container clusters update cluster-name \
    --release-channel channel
```

## References

- [Upgrade your GKE infrastructure in a timely fashion (default 2019-11-11)](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#upgrade_your_infrastructure_in_a_timely_fashion_default_2019-11-11)
- [Release channels](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels)
