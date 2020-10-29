# iam_members no_domains_grants

## Background

- For security-critical resources, avoid to bind role to a very large audience like a full domain name.
- Instead, bind IAM roles to groups.

Grants to domains in IAM are forbidden.

## Fix

Remove and replace the IAM binding with a narow audience.

```shell
gcloud organizations remove-iam-policy-binding ORGANIZATION --member=MEMBER --role=ROLE
gcloud resource-manager folders remove-iam-policy-binding FOLDER --member=MEMBER --role=ROLE
gcloud projects remove-iam-policy-binding PROJECT_ID --member=MEMBER --role=ROLE
```

## References

- [Least privilege](https://cloud.google.com/iam/docs/using-iam-securely#least_privilege)
