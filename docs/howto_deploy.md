# How to deploy Real-time Asset Monitor

## How to upgrade multiple environments to a new RAM release

1. From your RAM repo folder
2. Update `go.mod`
   - upgrade the `ram` module version to the new `vX.Y.Z`
3. Commit and push
   - commit message: `build: ram vX.Y.Z`
4. Compile `ramcli`
   - `go build ram.go`
   - Check GO downloaded the new `ram` version from GitHub

For each environment [dev, prd, ...], peform the following steps.  
The command examples are given for the `dev` environment. Replace as needed.  
If you do not used a ramcli service account then remove the `-ramcli` argument from the commands, else replace the service account email with yours.

1. Deploy all Cloud Build triggers
   - `./ram -pipe -environment=dev -ramclisa=ramcli@projectid.iam.gserviceaccount.com`
2. Check all Cloud Build triggers are running as configured in the code
   - `./ram -check -pipe -environment=dev -ramclisa=ramcli@projectid.iam.gserviceaccount.com`
3. Deploy all microservices all instances using the Cloud Build release pipelines
   - Get the last `ram` prefixed git tag version
     - `git tag -l "ram-*-dev"`
   - Create a new `ram` prefixed git tag
     - `git tag -a ram-A.B.C-dev -m "build: ram vX.Y.Z"`
   - Trigger the deployment by push this tag
     - `git push --tags`
4. Wait for the deployments to complete (+1 hour)
   - Check Cloud Build history filtering on:
     - Created after: YYYY/MM/DD
     - Status: Running OR Failed OR Expired
5. Check all the instances are running as configured in the code
   - `./ram -check -deploy -environment=dev -ramclisa=ramcli@projectid.iam.gserviceaccount.com`
6. Trigger all organization asset analysis by manually launching the related Cloud Scheduler jobs
   - Console / Cloud Scheduler / for each of the two jobs / `RUN NOW`
7. Check on the ram monitoring dashboard that the peak of cloud function activity is gone
8. Check results from DataStudio report
9. Check logs
    - Console / Logging / Logs viewer
    - Query

```stackdriver
resource.type="cloud_function"
textPayload:"ERROR - "
```

More to come:

- How to add a new asset type to RAM scope
- How to deploy new compliance rules in a granular way
- How to get new compliance rule templates
