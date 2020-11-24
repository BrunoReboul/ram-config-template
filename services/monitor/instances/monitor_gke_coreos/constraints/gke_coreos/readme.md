# gke_coreos

## Background

Container-Optimized OS from Google is an operating system image for your Compute Engine VMs that is optimized for running Docker containers. Container-Optimized OS is maintained by Google and based on the open source Chromium OS project. With Container-Optimized OS, you can bring up your Docker containers on Google Cloud Platform quickly, efficiently, and securely.

GKE Clusters' Nodes with OS image other than COS are forbidden.

## Fix

Replace nodPools images.

[Creating and configuring instances using COS](https://cloud.google.com/container-optimized-os/docs/how-to/create-configure-instance)

## References

- [Container-Optimized OS features, benefits, limitations](https://cloud.google.com/container-optimized-os/docs/concepts/features-and-benefits)
- [Security features of COS](https://cloud.google.com/container-optimized-os/docs/concepts/security)
