# iam_members no_public_access_bq_dataset_gcs_bucket

## Background

Nerver bind a role to a public audience for Bigquery datasets and Cloud Storage Buckets.
Instead, bind IAM roles to groups.

Public access to BQ Datasets and GCS Buckets are forbidden.

## Fix

Remove and replace the IAM binding with a narow audience.

```shell
gcloud organizations remove-iam-policy-binding ORGANIZATION --member=MEMBER --role=ROLE
gcloud resource-manager folders remove-iam-policy-binding FOLDER --member=MEMBER --role=ROLE
gcloud projects remove-iam-policy-binding PROJECT_ID --member=MEMBER --role=ROLE

bq show \
--format=prettyjson \
project_id:dataset > path_to_file

bq update \
--source path_to_file \
project_id:dataset

gsutil iam ch MEMBER_TYPE:MEMBER_NAME:IAM_ROLE gs://BUCKET_NAME
```

## References

- [Least privilege](https://cloud.google.com/iam/docs/using-iam-securely#least_privilege)
- [Controlling access to datasets](https://cloud.google.com/bigquery/docs/dataset-access-controls)
- [Using IAM permissions](https://cloud.google.com/storage/docs/access-control/using-iam-permissions)
