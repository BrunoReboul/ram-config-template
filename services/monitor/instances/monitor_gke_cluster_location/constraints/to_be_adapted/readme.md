# gke_cluster_location to_be_adapted

## Background

GKE cluster location have to comply with data soveriegnty regulation

You cannot modify whether a cluster is zonal, multi-zonal, or regional after creating the cluster.

## Fix

Adding or removing zones: All zones must be in the cluster's region. So, when a cluster runs in a non compliant region or zone(s), you need to provision a new cluster in a compliant region or zone(s), deploy applications, drain the traffic to the new cluster and delete the non compliant cluster.

```shell
gcloud container clusters create cluster-name \
    --release-channel channel \
    --zone compute-zone \
    --node-locations compute-zone,compute-zone,[...]

gcloud container clusters delete [CLUSTER_NAME]
```

## References

- [Data sovereignty](https://en.wikipedia.org/wiki/Data_sovereignty)
- [GDPR General Data Protection Regulation](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32016R0679)
- [GKE location](https://cloud.google.com/about/locations#europe)
- [Cluster availability choices](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#availability)
