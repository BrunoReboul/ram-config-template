# gke_alias_ip_range

## Background

In GKE, clusters can be distinguished according to the way they route traffic from one Pod to another Pod.

- A cluster that uses **alias IP address ranges** is called a **VPC-native cluster**.
- A cluster that uses custom static routes in a VPC network is called a routes-based cluster.

GKE clusters must be VPC-native cluster, aka using alias IP address ranges.

## Fix

This settings cannot be updated, the cluster need to be re-created

```shell
gcloud container clusters create cluster-name \
  --region=region \
  --enable-ip-alias \
  --subnetwork=subnet-name \
  --cluster-ipv4-cidr=pod-ip-range \
  --services-ipv4-cidr=services-ip-range
```

## References

- [Benefits of VPC-native clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#benefits)
- [Creating a VPC-native cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips)
- [`gcloud container clusters update` has no option to update to alias ip range](https://cloud.google.com/sdk/gcloud/reference/container/clusters/update)
- [`gcloud container clusters create`](https://cloud.google.com/sdk/gcloud/reference/container/clusters/create)
