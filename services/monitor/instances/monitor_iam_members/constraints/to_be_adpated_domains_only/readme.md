# iam_members to_be_adpated_domains_only

## Background

Only `members` from known domains can be referenced in IAM policies. All others are considered as intruders.

## Fix

Provides a company managed identities to partners.
Add these users to a managed groups having the desired roles for the scoped resources.
Remove the non compliant identities from IAM policies.

## References

- [IAM Policies](https://cloud.google.com/iam/docs/reference/rest/v1/Policy)
- [You domain list from Google Admin console](https://admin.google.com/ac/domains/manage)
