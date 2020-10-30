# gke_private_cluster

## Background

Private clusters give you the ability to isolate nodes from having inbound and outbound connectivity to the public internet. This isolation is achieved as the nodes have internal IP addresses only. Private Google Kubernetes Engine (GKE) cluster is a type of VPC-native cluster.

If you want to provide outbound internet access for certain private nodes, you can use Cloud NAT or manage your own NAT gateway, and use Load Balancers.

GKE Clusters must be Private.

## Fix

```shell
gcloud container clusters create private-cluster-0 \
    --create-subnetwork name=my-subnet-0 \
    --enable-master-authorized-networks \
    --enable-ip-alias \
    --enable-private-nodes \
    --enable-private-endpoint \
    --master-ipv4-cidr 172.16.0.32/28 \
    --no-enable-basic-auth \
    --no-issue-client-certificate
```

## References

- [Private clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept)
- [Creating a private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
- [Benefits of VPC-native clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#benefits)
