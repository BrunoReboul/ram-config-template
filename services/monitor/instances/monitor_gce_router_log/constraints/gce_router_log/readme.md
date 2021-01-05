# monitor_gce_router_log gce_router_log

## Background

GCE Cloud Router must log ALL requests

For accountability issues and to help troubleshooting, Cloud Router should have logging enabled and log all events, translations AND errors.

## Fix

```shell
gcloud compute routers nats update NAT_GATEWAY \
    --router=ROUTER_NAME \
    --region=REGION \
    --log-filter=ALL
```

## References

- [Cloud NAT, Using Logging and Monitoring](https://cloud.google.com/nat/docs/monitoring)
