# cloudsql_ssl

## Background

Cloud SQL creates a server certificate automatically when you create your instance. To use SSL/TLS you need to create a client certificate and download the certificates to your MySQL client host machine.

When requiring SSL/TLS is enabled, you can either use the Cloud SQL Proxy or SSL/TLS certificates to connect to your Cloud SQL instance. If you do not require SSL/TLS, clients without a valid certificate are allowed to connect.

CloudSQL Instances accesses must be ciphered.

## Fix

```shell
gcloud sql instances patch [INSTANCE_NAME] --require-ssl
```

## References

- [Requiring SSL/TLS](https://cloud.google.com/sql/docs/mysql/configure-ssl-instance#enforcing-ssl)
