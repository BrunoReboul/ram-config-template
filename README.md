# ram-config-template

Real-time Asset Monitor configuration template to be cloned and adapted to your environment

## Clone this repo to initialize your RAM configuration repo

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

The list of nanual tasks to complete has been listed by `ram-init`

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
