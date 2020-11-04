# Using Real-time Asset Monitor with multiple GCP organizations - WORK IN PROGESS

## From monitored organizations

- Create the custom org role `ram_cli_monitoring_org_extended` as documented in the [pre-requisites](pre_requisites.md)
- From GCI Admin console (aka gSuite...Workspace) Domains / Whitelisted domains
  - Add the domain name of the GCP organization hosting the RAMCLI service account
- Assign the custom org role `ram_cli_monitoring_org_extended` to the RAMCLI service account
