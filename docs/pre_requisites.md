# RAM pre-requisites

## 1 Create a folder

To contain RAM projects, ussually one per environment.

## 2 Create a group and grant permissions

This group materialize the team in charge of RAM.
The team will have to perform a few manual operations from the console as they are not automatable. To do so the group is granted with permissions described in [this section](#assign-roles-to-RAM-team-group).

To use ram cli the team setup the environment variable [GOOGLE_APPLICATION_CREDENTIALS](https://cloud.google.com/docs/authentication/production) on the service account describe in [this section](#3-create-RAM-Cli-service-account). This service account have the permissions required to run ram cli, so the team does no need nor have them.

### Assign roles to RAM team group

- Scope: on RAM folder
- Roles
  - `roles/viewer`
  - To manually setup firebase native mode, to give domain wide delegation could be expired with a time condition
    - `roles/datastore.owner` datastore permission are not supported in custom roles
    - Custom role to carry permissions
    - `appengine.applications.create`
    - `storage.buckets.create`
    - `servicemanagement.services.bind`
    - `iam.serviceAccounts.update`
    - `clientauthconfig.clients.update`
  - To create a connected source repo and manage it
    - `roles/source.admin`

## 3 Create RAM Cli service account

Service account to be used to run RAM cli using GOOGLE_APPLICATION_CREDENTIALS environment variable or `gcloud auth activate-service-account`.

### Permisions and recommended roles

When ram cli have a full set of roles (core and extended) it can automate the installation end to end from project creation to instance deployment.

When ram cli have just the core set of roles, the missing deployment actions have to be performed by the team who own these roles and related tasks.

#### `ram_cli_folder_core`

- `cloudbuild.builds.create`
- `cloudbuild.builds.get`
- `cloudbuild.builds.list`
- `source.repos.create`
- `source.repos.get`

#### `ram_cli_folder_extended`

- `iam.roles.create`
- `iam.roles.get`
- `iam.roles.update`
- `iam.serviceAccounts.create`
- `iam.serviceAccounts.get`
- `iam.serviceAccounts.getIamPolicy`
- `iam.serviceAccounts.list`
- `iam.serviceAccounts.setIamPolicy`
- `resourcemanager.folders.get`
- `resourcemanager.projects.create`
- `resourcemanager.projects.createBillingAssignment`
- `resourcemanager.projects.get`
- `resourcemanager.projects.getIamPolicy`
- `resourcemanager.projects.setIamPolicy`
- `serviceusage.services.enable`
- `serviceusage.services.get`
- `serviceusage.services.list`

#### `ram_cli_monitoring_org_extended`

- `cloudasset.feeds.create`
- `cloudasset.feeds.delete`
- `cloudasset.feeds.get`
- `cloudasset.feeds.list`
- `iam.roles.create`
- `iam.roles.get`
- `iam.roles.list`
- `iam.roles.update`
- `resourcemanager.organizations.get`
- `resourcemanager.organizations.getIamPolicy`
- `resourcemanager.organizations.setIamPolicy`

#### Billing account scope role binding

- `billing.resourceAssociations.create` roles/billing.user

### The following API must be active on the project hosting the ram cli service account

- Cloud Resource Manager
- Cloud Billing
- Identity and Access Management
- App Engine Admin
- Cloud Build
- Cloud Asset

### Use a service account to run ram cli, do not use a user account

Cloud Asset Inventory requires it:

`rpc error: code = PermissionDenied desc = Your application has authenticated using end user credentials from the Google Cloud SDK or Google Cloud Shell which are not supported by the cloudasset.googleapis.com. We recommend configuring the billing/quota_project setting in gcloud or using a service account through the auth/impersonate_service_account setting. For more information about service accounts and how to use them in your application, see https://cloud.google.com/docs/authentication/.`

## Export gSuite activity logs to GCP organization

This step is required to enable near real-time analyis of group changes.  
From gSuite admin console, Account settings / Legal and Compliance / Sharing option / Enable.  
Doc: [Share data with Google Cloud Platform services - G Suite Admin Help](https://support.google.com/a/answer/9320190)

## Domain Wide Delegation

When to perform theses tasks? After creating the builds (ram -pipe) so the services accounts for the cloud functions have been created for the services listed below.  
Manually configure domain wide delegation from GCP console for the following service accounts. Give them the Oauth scopes as described below from admin.google.com console.  

From GCP console for earch service account enable domain wide delegation and keep track of their account IDs.  
From gSuite Admin console / Security / API management / Domain wide delegation, grant to the service accounts the following scopes using their account IDs.

### listgroups service account

- `https://www.googleapis.com/auth/admin.directory.group.readonly`
- `https://www.googleapis.com/auth/admin.directory.domain.readonly`

### listgroupmembers service account

- `https://www.googleapis.com/auth/admin.directory.group.member.readonly`

### getgroupsettings service account

- `https://www.googleapis.com/auth/apps.groups.settings`

### convertlog2feed service account

- `https://www.googleapis.com/auth/admin.directory.group.readonly`
- `https://www.googleapis.com/auth/apps.groups.settings`
