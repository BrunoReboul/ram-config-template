# gke_stackdriver_logging

## Background

Sending logs and metrics to a remote aggregator mitigates the risk of local tampering in the event of a breach and ensures availability of audit data following a cluster security event. It provides a central location for analysis.

Currently, there are two mutually exclusive variants:

- Legacy logging and monitoring for GKE
- Cloud operation for GKE.

Cloud operation for GKE is the prefered option. The use of either of these services is sufficient to fix the non-compliance.

GKE Clusters must have Kubernetes Engine monitoring enabled.

## Fix

To enable cloud operation for GKE:

```shell
gcloud beta container clusters update [CLUSTER_NAME] \
  --zone=[ZONE]  --region=[REGION]  \
  --logging-service logging.googleapis.com \
  --monitoring-service monitoring.googleapis.com
  
```

To enable legacy logging and monitoring for GKE:

```shell
gcloud beta container clusters update [CLUSTER_NAME] \
  --zone=[ZONE]  --region=[REGION]  \
  --logging-service logging.googleapis.com \
  --monitoring-service monitoring.googleapis.com
  
```

## References

- [Installing Cloud Operations for GKE support](https://cloud.google.com/stackdriver/docs/solutions/gke/installing)
