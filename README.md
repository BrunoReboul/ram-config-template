# ram-config-template

Real-time Asset Monitor configuration template to be cloned and adapted to your environment

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
    - directoryCustomerIDs
- In `./services/monitorcompliance/instances`
  - review, adapt each compliance rule
    - REGO template
    - YAML constrains files
  - create additional compliance rules as needed
- Once settings are tailored to your context do not forget to commit changes in your git repo

## Install GO

- Which GO version should be installed?
  - The version that appears in `./go.mod`
- How to install GO?
  - [GO Getting started](https://golang.org/doc/install)

## Build RAM cli

`go build ram.go`

## Initialize setup

`ram -init`  
run `ram` with no arguments to see available options

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

## Make cloud build triggers

- `ram -make-trigger`
- Check results in console / cloud build / triggers

## Tag to deploy RAM microservices instances

- `git tag -a ram-vx.y.z-env -m "your message"`
  - example `git tag -a ram-v0.0.1-dev -m "initial deployment"`
- `git push --tags`
- Check results in console / cloud build / history

## Manually trigger an initial compliance assessment

- RAM detect non compliances in near real time on asset changes
- Only trigger a full assessment apart from the real-time flow when
  - You just install RAM and need a first assessment
  - You change rules
- How to?
- console / cloud scheduler / Jobs / Start now

## Review compliance results

Several options:

- Use DataStudio template
- Use your own dashboarding tool (need BigQuery connector)
- Query BigQuery views from the console
- Integrate compliance result directly in your applications
