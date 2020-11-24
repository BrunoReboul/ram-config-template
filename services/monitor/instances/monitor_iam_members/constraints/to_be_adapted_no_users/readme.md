# iam_members to_be_adapted__no_users

## Background

IAM bindings should not reference users directly but groups

## Fix

- Create or reuse a group
- Add the user to the group
- Grant the group the role on the resource(s)
- Remove the binding on the user

## References

- [IAM Policies](https://cloud.google.com/iam/docs/reference/rest/v1/Policy)
