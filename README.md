# RAM v1 is now deprecated, please use [RAMv2](https://gitlab.com/realtime-asset-monitor/setup)

=> [go to RAMv2](https://gitlab.com/realtime-asset-monitor/setup)

ram-config-template  

Real-time Asset Monitor configuration template to be cloned and adapted to your environment.  
[Product overview.](docs/product_overview.md)

## Customize compliance rules

**[Compliance rules table of content](services/monitor/readme.md)** including links on *how to remediate*.

Compliance rules [**export to CSV format**](services/monitor/constraints.csv).

RAM complement other GCP compliance tools by brining the ability to define **custom rules**, so it is time to customize :-)

- In `./services/monitor/instances`
  - This folder contains rules as REGO code and `constraints.yaml` settings to be reviewed, and adapted
    - `target` and `exclude` lists enable to define the relevant scope in your GCP hierarchy for each rule
    - `exemptions` lists enable to whitelist specific assets when available
    - Several settings need to be adapted like all rules related to **data sovereignty**
      - A search in this folder for the string `to_be_adapted` will directly point you to them
  - create additional compliance rules as needed
- Once settings are tailored to your context do not forget to commit changes in your git repo## Clear pre-requisites

Folder, group, service account and permission pre-requisites are described [HERE](docs/pre_requisites.md)

## Clear pre-requisites

Folder, group, service account and permission pre-requisites are described [HERE](docs/pre_requisites.md)

## Clone this repo to initialize your RAM configuration repo

- Why?
  - With RAM you can customize compliance rules to match your specific need
  - So, a git repo is needed to keep tracks of your own configuration adaptations
  - Instead of starting from a blank page, this `ram-config-template` offers you a ready to use starting point
- What?
  - Just clone this repo to initiate your own
- How?
  - [Cloning a GitHub repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository)

## Review adapt settings

- In `./solution.yaml` adapt at least
  - hosting
    - folder ID
    - `dev` project ID
    - `dev` Stackdriver workspace host project ID
    - repository / name
    - buckets names
  - monitoring
    - organizationIDs
    - directoryCustomerIDs and associates super admin emails
    - Keep list group scheduler different from other scheduler (do NOT mutualize) as the associated topic is used recursively to scale GCP queries

## Install GO

- Which GO version should be installed?
  - The version that appears in `./go.mod`
- How to install GO?
  - [GO Getting started](https://golang.org/doc/install)

## Build RAM cli

`go mod tidy`  
`go build ram.go`

## Set GOOGLE_APPLICATION_CREDENTIALS environment variable

Recommended:

Set GOOGLE_APPLICATION_CREDENTIALS envrionment variable to the ram cli service account prepared as described in the [pre requsistes](docs/pre_requisites.md) so ram cli will be run for the following step using this identity.

Quick and dirty:

You just want to explore `ram` in a sandbox environment and to not want to spend time in clearing the pre-reauisites (custom roles, team group, service account ...).
Create a folder for `ram` and follow the next steps using a user account with full accesses to your sandbox GCP organization resources and GCI directory.

## Initialize setup

- `ram -init`
- run `ram` with no arguments to see available options

## Complete manual setup task

- The list of nanual tasks to complete has been listed by `ram-init`
- More info about RAM cloud source repo
  - RAM Continuous Deployment pipeline uses the git repo you have set in `solution.yaml` as it source of truth
  - This repo is hosted in each of you RAM GCP projects (dev, prd ...) using Google Cloud Source
  - So, how to synchonize the local git repo initiate at the begining with Cloud Source ?
    - This is the purpose of the manual step number 3 listed at the end of the `ram -init` step
    - Several options:
      - Option 1: [Push the local repo directly to Cloud Source](https://cloud.google.com/source-repositories/docs/pushing-code-from-a-repository)
      - Option 2: Use an external git repo hosting provider, like GitHub or Bitbucket
        - First, push the local repo to the external provider platform
        - Then, [mirror from the external provider into Cloud Source](https://cloud.google.com/source-repositories/docs/mirroring-repositories)

## Create microservices instances yaml configuration files

- `ram -config`
- This step takes a couple of seconds
- Review added configurations in `services` folder, per service subfolders

## Make cloud build release pipelines

- `ram -pipe`
- This step takes about 15 minutes for 1 GCP organization
- Check results in console / cloud build / triggers
- `ram -pipe -check` to check each cloud build trigger has been deployed and configured as specified in the yaml code

## Tag to deploy RAM microservices instances

**Heads up** Cloud build on a brand new project:

- Launching more than 100 cloud build jobs simultaneously, on a brand new project where cloud build had never been used, may lead to fail the first hundred with the error `Your build failed to run: generic::invalid_argument: invalid bucket "10blabla19.cloudbuild-logs.googleusercontent.com"; builder service account does not have access to the bucket`
- Once cloud build has been use at least once on the project it is possible to launch several hundreds of builds, but not yet.
- To work arround this issue, lets launch one build first by using the following commands:
  - `git tag -a splitdump_single_instance-v0.0.1-dev -m "initial deployment"`
  - `git push --tags`
  - Check results in console / cloud build / history. Proceed to next steps only once cloud build has run at least one job successfully.

Then launch the full deployment:

- `git tag -a ram-vx.y.z-env -m "your message"`
  - example `git tag -a ram-v0.0.1-dev -m "initial deployment"`
- `git push --tags`
- This step takes about an hour for +150 builds to run by 10 in parallel (default quota, default cloud build instance)
- `ram -deploy -check` to check each microservice instance has been deployed and configured as specified in the yaml code
- Check also results in console / cloud build / history
  - A few builds may failed (e.g. on github timeout), just hit the `retry` button
  - Specific manual operations to finalise `listgroups` `listgroupmembers` `getgroupsettings` deployment
    - Configure DwD Domain wide delegation fronm GCP console on the 3 related service accounts
    - Configure Oauth scopes from the admin.google.com console. Scopes for each service accounts are list in deploment log or in [pre-requsites]((docs/pre_requisites.md))
- Check results also in console / functions
  - a few function may be broken (e.g. on github timeout), just relaunch the associated build by hitting the `retry` button

## Manually trigger an initial compliance assessment

- RAM detect non compliances in near real time on asset changes
- Only trigger a full assessment apart from the real-time flow when
  - You just install RAM and need a first assessment
  - You change rules
- How to?
- console / cloud scheduler / Jobs / Start now

## Review compliance results

Several options:

- Query BigQuery views from the console as a smoke test
- Use [Data Studio template](https://datastudio.google.com/reporting/467c7ff1-7220-4de9-a0fe-536bdad7aee1) and follow the README instructions embeeded in the report template
- Use your own dashboarding tool (need BigQuery connector)
- Integrate compliance result directly in your applications using BigQuery APIs

## What's next

[FAQ](docs/FAQ.md)  
[Known errors](docs/known_errors.md)  
[RAM microservice packages on go.dev](https://pkg.go.dev/github.com/BrunoReboul/ram)
