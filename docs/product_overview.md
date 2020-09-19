# Realtime Asset Monitor - product overview

A compliance service to detect in near real time configuration violations in GCP IAM policies, GCP resources settings and GCI group memberships.

## Improve security, reduce outages, avoid resource waste

Configuration compliance mainly relates to security rules: data sovereignty, whitelist of DNS domains you own for your brands etc… It also applies to operation excellence. For example, to ensure production Cloud SQL instances do have a defined maintenance window to avoid untimely service interruption. It applies to Cloud cost optimization too. For example, to ensure the types of Virtual Machines deployed match those you have committed for discount usage.

## Leverage real time to ease remediation

Fixing a misconfiguration is well accepted when it can be done immediately. It is the opposite way for long running non compliance: no one wants to endorse the responsibility of changing a running production critical system without a clear view on the potential impacts. Bad news should travel fast, equally should do the misconfiguration alerts. RAM is near real time by design.

## Focused on custom configuration rules

Taking in account the specific constraints your organization needs to comply with is essential: Example, your data sovereignty rules may be different in Europe (GDPR), in Asia and in the US. Being specific about the scope is equally important: Rules for production systems differ from rules in the sandbox environment. Defining custom configuration rules lead to relevant non compliances, and avoid wasting time on noisy useless false positives. RAM does not compete with generic threat detection systems. It complements these services by letting you define custom rules.

## Implement rules gradually

Compliance programs are dynamic: rules change as threats evolve, scopes move as your company grows, the affordable amount of effort to fix non compliances is driven by multiple factors. The serverless design of RAM enables the deployment of rules gradually. Both rule quality and release velocity are improved, as each rule can be built, tested and deployed to production independently.

## Features

### Open source

No license fee, feel free to test and use RAM. Running costs are especially low as all components are serverless and scale down to zero. You are welcome to join the community on [GitHub](https://github.com/BrunoReboul/ram/issues) to improve RAM and influence its future in a way that meets your requirements.

### Focus only on configuration compliance

No need to waste time managing RAM Virtual Machines, Databases or Network: there is no infrastructure to manage. You can focus on your goal: configuration compliance. RAM uses [Cloud Asset Inventory](https://cloud.google.com/asset-inventory/docs), [BigQuery](https://cloud.google.com/bigquery/docs), [Cloud Functions](https://cloud.google.com/functions/docs), [Pub/Sub](https://cloud.google.com/pubsub/docs), [Cloud Scheduler](https://cloud.google.com/scheduler/docs), [DataStudio](https://datastudio.google.com), [Firestore](https://firebase.google.com/docs/firestore). [Cloud Build](https://cloud.google.com/cloud-build/docs), [Cloud Source](https://cloud.google.com/source-repositories/docs) and [Open Policy Agent](https://www.openpolicyagent.org/).

### Fast full assessment

Not only configurations change, compliance rules change too. In such cases you need a full assessment of all assets related to the updated rules. RAM provides batch mode in complement of real time mode. Leveraging the Cloud Function's massive parallel scalability leads to delivering all results usually in 10 to 15 minutes, not hours or days.

### Reliable

Accept failure as normal is a great starting point to build a reliable product. Each RAM microservice is implemented as an idempotent background Cloud Function, allowing it  to recover from transient errors.

### Fully automated deployments

RAM architecture relies on a dozen of microservices, leading to deploying more than 100 Cloud Functions. This provides the wanted agility. It also brings more complexity than a monolith app would do. On purpose RAM integrates a fully automated deployment pipeline enabling to redeploy everything or just one service or just one service instance, as you wish.

### GitOps

Automated RAM deployments are triggered from git Tags in a GitOps spirit. Further, your git repository mainly contains custom rules code in REGO and their settings in YAML. The GO code running in the cloud functions is segregated in a public versioned git repository you do not have to worry about.

### Fast equals lower costs

Short execution time is top of mind when running cloud functions as CPU GHz/s and RAM MB/s are key bill drivers. Each RAM microservice is implemented using the Cloud Function cold start feature to cache objects long to initialize which in turn reduces each triggered execution time. The cost to run RAM is highly optimized as real time detection triggers only when a change occurs in a specific asset type. Moreover all the serverless GCP components used to run RAM can scale down to zero: no usage, no cost.

### Extensible

Enterprises can extend RAM via two channels. First, through a simple SQL access to the violations and compliance status BigQuery tables, easy to integrate with in-house App and BI platforms. Second, by consuming directly the real time flow from the PubSub violations topic.
