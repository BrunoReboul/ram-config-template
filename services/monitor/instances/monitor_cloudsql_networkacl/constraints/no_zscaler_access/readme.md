# cloudsql_networkacl no_zscaler_access

## Background

Acces to CloudSQL Instances from Zscaler is forbidden.

Zscaler blacklist IP blocks: `165.225.76.0/23` `165.225.88.0/23`

## Fix

```shell
gcloud sql instances describe [INSTANCE_NAME]
gcloud sql instances patch [INSTANCE_NAME] --authorized-networks=[IP_ADDR1],[IP_ADDR2]...
```

## References

- [Removing an authorized address or address range](https://cloud.google.com/sql/docs/mysql/configure-ip#remove)
- [Configuring an instance to refuse all public IP connections](https://cloud.google.com/sql/docs/mysql/configure-ip#all)
