# iam_bindings_roles no_primitives_on_org

## Background

- For security-critical resources, avoid primitive roles, such as (roles/owner, roles/editor, and roles/viewer).
- Instead, grant predefined roles to allow the least-permissive access necessary.
- Remember that the policies for child resources inherit from the policies for their parent resources
- Grant roles at the smallest scope needed

Primitives roles are not authorized on organizations

## Fix

Remove the IAM binding.

```shell
gcloud organizations remove-iam-policy-binding ORGANIZATION --member=MEMBER --role=ROLE
```

## References

- [Least privilege](https://cloud.google.com/iam/docs/using-iam-securely#least_privilege)
