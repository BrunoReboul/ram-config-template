# Known errors

## Invalid JWT signature

This error description may be found in `listgroups`, `listgroupmembers` and `getgroupsettings` logs. It may take several hours (24 ?) to get the configured Oauth scopes for Domain-wide delegation DwD from admin.google.com console to be effective.

## dumpinventory or splitdump deployment: Error 409: Sorry, that name is not available. Please try a different one., conflict

The name of the bucket to create that will host cloud asset inventory exports is already used. This may be because you delete the full project, and while the project is deletion pending for 30 days the associated storage buckets names are not released. Resolution: use different project and  buckets names in solution.yaml, for example with a suffix number.

## Potentially insufficiant quotas

### 100 Cloud Asset Inventory feeds at organization level

`ERROR: (gcloud.beta.asset.feeds.create) RESOURCE_EXHAUSTED: Resource has been exhausted (e.g. check quota).` This quota does not appear in the console.  
The total number of CAI feeds at organization level is by default limited to 100.  
If you plan to monitor 82 resource types, and one more for iam policies, it make 83 feeds.  
If want to test everything in dev environment before moving to production environment it makes 2x83 = 166 > 100.  
Then open a support request to increase the quota to 200.  

### Admin SDK API (GCI) 4000 queries per 100 seconds

Console / API / Admin SDK API / Quotas / Queries. The defauft quotas is 4000. Depending on the number of group to analyze it may be worth asking for a quota increase. E.g. 15000. If the quota is inssuficiant, `listgroups` and `listgroupmembers` microservices will still be able to analyze all groups but with a significant number of retries, leading to potential extra CPU usage.

### Groups Settings API (GCI) 500 queries per 100 seconds

Console / API / Groups Settings / Quotas / Queries. The default quotas is 500. The comment has the previous section.

### Cloud Build API, 10 concurent builds

Console / API / Cloud Build API / Quotas / Concurrent builds.  
Default quota is 10.  
Running all RAM deployments in parallel (+150) takes arround 1 hour with the default 10 concurrent builds.  
You may be interrested to request a higher quotas to speedup a full deployment, specially if you contribute to RAM development effort and redeploy everything on a regular basis for dev testing purposes.
