# iam_bindings_roles no_billing_account_creator

## Background

There is already one billing account, and there is not need to create more.
So, the `Billing Account Creator` role should not be bind.

Only one billing account, not need to create any other.

## Fix

Remove the IAM binding.

```shell
gcloud organizations remove-iam-policy-binding ORGANIZATION --member=MEMBER --role=ROLE
```

## References

- [Cloud Billing access control](https://cloud.google.com/billing/docs/how-to/billing-access)
