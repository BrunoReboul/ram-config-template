# iam_sa_key_age

## Background

Rotating Service Account keys will reduce the window of opportunity for an access key that is associated with a compromised (lost, cracked, or stolen) or terminated account to be used.

Each service account is associated with a key pair managed by Google Cloud Platform (GCP). It is used for service-to-service authentication within GCP.

Google rotates Google managed keys daily.

GCP provides the option to create one or more user-managed (also called external key pairs). When a new key pair is created, the user is required to download the private key (which is not retained by Google). With external keys, users are responsible for keeping the private key secure and other management operations such as key rotation.

External keys can be managed by the IAM API, gcloud command-line tool, or the Service Accounts page in the Google Cloud Platform Console.

GCP facilitates up to 10 external service account keys per service account to facilitate key rotation.

Rotating service account keys will break communication for dependent applications. Dependent applications need to be configured manually with the new key ID displayed in the Service account keyssection and the private key downloaded by the user.

Service Accounts keys should not be older than 100 days.

## Fix

```shell
gcloud iam service-accounts keys list \
  --iam-account sa-name@project-id.iam.gserviceaccount.com

gcloud iam service-accounts keys create ~/key.json \
  --iam-account sa-name@project-id.iam.gserviceaccount.com

gcloud iam service-accounts keys delete key-id \
  --iam-account sa-name@project-id.iam.gserviceaccount.com
```

## References

- [Managing service account keys](https://cloud.google.com/iam/docs/understanding-service-accounts#managing_service_account_keys)
- [Service accounts](https://cloud.google.com/iam/docs/service-accounts)
