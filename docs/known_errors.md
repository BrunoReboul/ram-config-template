# Known errors

## Invalid JWT signature

### Case one: scope not yet effective

This error description may be found in `listgroups`, `listgroupmembers` and `getgroupsettings` logs. It may take several hours (24 ?) to get the configured Oauth scopes for Domain-wide delegation DwD from admin.google.com console to be effective.

### case two: convertlog2feed

Convertlog2feed runs constantly as it is a near realtime service when deploy on a large gSuite directory. In consequence the function cold start is executed multiple times per minutes. The cold start contain a servie account key clean up mecanism that delete all the non system key but the active one.

What if convert2log is redeployed while it is still actice? Then, cloud build create a new key (to automate key rotation) that is killed by the active cloud function before the new version is deployed (2 minutes time frame). This issue does not show up on test environment where the real time traffic is too low.

Work arround: delete the current convertlog2feed cloud function before re deploying it, at the cost of lossing some real time events. This will be covered by the next scheduled export.

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

### Cloud Function build time in seconds per day

Quota exceeded for quota group 'BuildTime' and limit 'Functions build time in seconds per day' of service 'cloudfunctions.googleapis.com'  
Console / API / Cloud Function API / Quotas / Function buildtime in seconds per day  
According to documentation the default quotas for [Max build time](https://cloud.google.com/functions/quotas#time_limits) is 120 minutes, 2 hours, per project.  
When installing RAM this quota appears to be automaticcaly increased to 36 000 seconds, 10 hours, so 5x times more.  
36 000 seconds is the maximun requestable value.  
From data available in Cloud Build build logs, step 3 takes 2 to 3 minutes. It includes prerequistes task and cloud function deployment. So using 3 minutes as the build time for a cloud function is conservative.  
600 min daily quota / 3 min = 200 cloud function deploymenta a day.  
RAM has arround 130 cloud functions depending on the number of rules and asset to monitor.  
So it is ok to redeploy all one a day.

### Cloud build triggers

Default 300 triggers per projects. May be upgraded to 500.

### CPU allocation in function invocation for 'region-zone' per 100 seconds

Console / API / Functions / Quotas / CPU Allocation in functions invocations.
Quotas hit during large export processing. Not for near realtime processing,
Retries handles the errors over the 100 sec window. To avoid extra cost due to retry, request a higher quota.

## Cloud Build

### log not ready

message type: `invalid logs bucket "gs://<number>.cloudbuild-logs.googleusercontent.com": builder service account does not have access to logs bucket "<number>.cloudbuild-logs.googleusercontent.com"`  
Deploy starts while cloud build internal bucket for log was not yet ready, or permission not yet ready.  
Should occurs only on the very first wave of builds.  
Just retry the failed build.  
Mitigation: fire only one build, then fire all builds.  

### back end error

Error 503 backend error when running `./ram -pipe`  
Transient, retry.

## IAM

Running `./ram -pipe`  
Error 404 service account not found on service account creation operation.  
Transient, wait and retry.

## publish2fs logs

### `An internal error occurred` on SET document

Probably a transient from Firestore.  
Filter logs on `textPayload:"<the folder or project ID>"`
This will list all re retry for a given asset an eventually the success after the transients

## convertlog2feed

### Some actions are not advertised in Admin Activity Report Event

Missing:

- When a user (or other secruity principal) is deleted, there is not event to notify the groups it is member of have changed
- Changing a group primary email address leads to NO events

In consequences these events are not cached by RAM, leading to potential orphan violations.
