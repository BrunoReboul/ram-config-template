# Frequently asked questions

## Is RAM using custom IAM roles`?`

Yes.  
This [map](https://www.mindmeister.com/149967) may be useful to have a summary of custom roles used by RAM.

## **Is `ram` a serverless solution`?`**

Yes, `ram` is a set of microservices implemented with Google Cloud Funtions, communication through PubSub messages

## **Are compliance rule deployments granular in `ram` `?`**

Yes, each compliance rule is an instance of `monitor-compliance` microservice. It can be deploy independently from other rules.

- It limit the **blast radius** to the only rule being changed.
- It avoid **scallability** issue, each rule being executed isolated with its own autoscallability capacity provided out of the box by the underpining Google Cloud Function
- It optimize run **cost**, each rule being triggered only when the related resources configuration changes. For example a Cloud SQL config change to NOT trigger the Kubernetes rules.
- It saves time by having short deployment duration leading to rapid test results, increased **velocity** in creating and stabilizing new rules, which dirrectly  enable to extend the **compliance scope**.

## **If a asset is deleted, does RAM still display the asset compliance status and violations `?`**

- NO, on purpose, this avoid to waste energy in fixing issue that do not exist anymore :-)
- When an asset is deleted, Cloud Asset Inventory Feed delivers a PubSub message with the filed `deleted: true`
- When Cloud Asset Inventory Export runs it does not export deleted assets.
- `monitor-compliance` microservice reports this information in the `complianceStatus` message and does not check the rego rule
- The view `last_compliancestatus` filter out statuses with `deleted=TRUE`
- the view `active_violations` is based on `last_compliacestatus`, so violations for deleted resources are not shown active

## **What are the settings of an running service instance really`?`**

- console / functions / select function / settings / settings.yaml
- This file contains all the settings used by this service instance.
  - It aggregates 3 levels solution, service and instance settings
  - Settings have bien situated:
    - craft some settings from others, like composed names
    - take the environment in account, like dev or production
