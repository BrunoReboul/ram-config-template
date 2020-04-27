# ram-config-template

Real-time Asset Monitor configuration template to be cloned and adapted to your environment

## Clone this repo to initialize your RAM configuration repo

## Review adapt settings

- `solution.yaml` at least
  - hosting
    - folder ID
    - `dev` project ID
    - `dev` Stackdriver workspace host project ID
    - repository / name
    - buckets names
  - monitoring
    - organizationIDs
    - directoryCustomerIDs

## Install GO

- Which GO version should be installed?
  - The version that appears in `go.mod`
- How to install GO?
  - [GO, Getting started](https://golang.org/doc/install)

## Build RAM cli

`go build ram.go`

## Initialize setup

`ram -init`  
run `ram` with no arguments to see available options

## Complete manual setup task

The list of nanual task has been listed by `ram-init`

## Make cloud build triggers

- `ram -make-trigger`
- Check results in console / cloud build / triggers

## Tag to deploy microservices instances

- `git tag -a ram-vx.y.z-env -m "your message"`
  - example `git tag -a ram-v0.0.1-dev -m "initial deployment"`
- `git push --tags`
- Check results in console / cloud build / history
