# Known errors

## Invalid JWT signature

This error description may be found in `listgroups`, `listgroupmembers` and `getgroupsettings` logs. It may take several hours (24 ?) to get the configured Oauth scopes for Domain-wide delegation DwD from admin.google.com console to be effective.

## dumpinventory or splitdump deployment: Error 409: Sorry, that name is not available. Please try a different one., conflict

The name of the bucket to create that will host cloud asset inventory exports is already used. This may be because you delete the full project, and while the project is deletion pending for 30 days the associated storage buckets names are not released. Resolution: use different project and  buckets names in solution.yaml, for example with a suffix number.
