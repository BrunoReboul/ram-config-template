# Compliance rules summary

Repository: **ram-config-template**

*Timestamp* 2020-11-09 09:06:57.289778116 +0100 CET m=+1.062367641

Service | rules | constraints
--- | --- | ---
**bq** | 1 | 1
**clouddns** | 2 | 2
**cloudsql** | 5 | 6
**gae** | 3 | 3
**gce** | 4 | 4
**gcs** | 1 | 1
**gke** | 12 | 12
**iam** | 3 | 8
**kms** | 1 | 1

9 services 32 rules 38 constraints

## bq

- dataset_location   - **[to_be_adapted](instances/monitor_bq_dataset_location/constraints/to_be_adapted/readme.md)** (*critical* Personnal Data Compliance)

## clouddns

- dnssec   - **[clouddns_dnssec](instances/monitor_clouddns_dnssec/constraints/clouddns_dnssec/readme.md)** (*major* Infrastructure Hardening)
- rsasha1   - **[clouddns_rsasha1](instances/monitor_clouddns_rsasha1/constraints/clouddns_rsasha1/readme.md)** (*critical* Debt Management)

## cloudsql

- backup   - **[cloudsql_backup](instances/monitor_cloudsql_backup/constraints/cloudsql_backup/readme.md)** (*major* Database Security)
- location   - **[to_be_adapted](instances/monitor_cloudsql_location/constraints/to_be_adapted/readme.md)** (*critical* Personnal Data Compliance)
- maintenance   - **[cloudsql_maintenance](instances/monitor_cloudsql_maintenance/constraints/cloudsql_maintenance/readme.md)** (*minor* Database Security)
- networkacl
  - **[no_public_access](instances/monitor_cloudsql_networkacl/constraints/no_public_access/readme.md)** (*major* Infrastructure Hardening)
  - **[no_zscaler_access](instances/monitor_cloudsql_networkacl/constraints/no_zscaler_access/readme.md)** (*medium* Infrastructure Hardening)
- ssl   - **[cloudsql_ssl](instances/monitor_cloudsql_ssl/constraints/cloudsql_ssl/readme.md)** (*major* Database Security)

## gae

- location   - **[to_be_adapted](instances/monitor_gae_location/constraints/to_be_adapted/readme.md)** (*major* Personnal Data Compliance)
- max_version   - **[traffic_split_to_more_than_2_versions](instances/monitor_gae_max_version/constraints/traffic_split_to_more_than_2_versions/readme.md)** (*medium* Debt Management)
- uses_iap   - **[to_be_adapted](instances/monitor_gae_uses_iap/constraints/to_be_adapted/readme.md)** (*major* Identity and Access Management)

## gce

- compute_zone   - **[to_be_adapted](instances/monitor_gce_compute_zone/constraints/to_be_adapted/readme.md)** (*major* Personnal Data Compliance)
- external_ip   - **[gce_external_ip](instances/monitor_gce_external_ip/constraints/gce_external_ip/readme.md)** (*major* Infrastructure Hardening)
- network_firewall_log   - **[gce_network_firewall_log](instances/monitor_gce_network_firewall_log/constraints/gce_network_firewall_log/readme.md)** (*medium* Traceability)
- network_firewall_rules   - **[no_public_access](instances/monitor_gce_network_firewall_rules/constraints/no_public_access/readme.md)** (*critical* Infrastructure Hardening)

## gcs

- storage_location   - **[to_be_adapted](instances/monitor_gcs_storage_location/constraints/to_be_adapted/readme.md)** (*critical* Personnal Data Compliance)

## gke

- abac   - **[gke_abac](instances/monitor_gke_abac/constraints/gke_abac/readme.md)** (*minor* Identity and Access Management)
- alias_ip_range   - **[gke_alias_ip_range](instances/monitor_gke_alias_ip_range/constraints/gke_alias_ip_range/readme.md)** (*medium* Infrastructure Hardening)
- allow_node_sa   - **[gke_allow_node_sa](instances/monitor_gke_allow_node_sa/constraints/gke_allow_node_sa/readme.md)** (*medium* Identity and Access Management)
- client_auth_method   - **[gke_client_auth_method](instances/monitor_gke_client_auth_method/constraints/gke_client_auth_method/readme.md)** (*major* Identity and Access Management)
- cluster_location   - **[to_be_adapted](instances/monitor_gke_cluster_location/constraints/to_be_adapted/readme.md)** (*major* Personnal Data Compliance)
- coreos   - **[gke_coreos](instances/monitor_gke_coreos/constraints/gke_coreos/readme.md)** (*medium* Infrastructure Hardening)
- dashboard   - **[gke_dashboard](instances/monitor_gke_dashboard/constraints/gke_dashboard/readme.md)** (*major* Infrastructure Hardening)
- disable_default_sa   - **[gke_disable_default_sa](instances/monitor_gke_disable_default_sa/constraints/gke_disable_default_sa/readme.md)** (*medium* Identity and Access Management)
- k8s_engine_logging   - **[gke_k8s_engine_logging](instances/monitor_gke_k8s_engine_logging/constraints/gke_k8s_engine_logging/readme.md)** (*major* Traceability)
- k8s_engine_monitoring   - **[gke_k8s_engine_monitoring](instances/monitor_gke_k8s_engine_monitoring/constraints/gke_k8s_engine_monitoring/readme.md)** (*major* Monitoring)
- private_cluster   - **[gke_private_cluster](instances/monitor_gke_private_cluster/constraints/gke_private_cluster/readme.md)** (*major* Infrastructure Hardening)
- version   - **[gke_version](instances/monitor_gke_version/constraints/gke_version/readme.md)** (*minor* Debt Management)

## iam

- bindings_roles
  - **[no_billing_account_creator](instances/monitor_iam_bindings_roles/constraints/no_billing_account_creator/readme.md)** (*minor* Identity and Access Management)
  - **[no_owner_no_editor_on_folders](instances/monitor_iam_bindings_roles/constraints/no_owner_no_editor_on_folders/readme.md)** (*major* Identity and Access Management)
  - **[no_primitives_on_org](instances/monitor_iam_bindings_roles/constraints/no_primitives_on_org/readme.md)** (*major* Identity and Access Management)
- members
  - **[no_domains_grants](instances/monitor_iam_members/constraints/no_domains_grants/readme.md)** (*major* Identity and Access Management)
  - **[no_public_access_bq_dataset_gcs_bucket](instances/monitor_iam_members/constraints/no_public_access_bq_dataset_gcs_bucket/readme.md)** (*major* Identity and Access Management)
  - **[to_be_adapted__no_users](instances/monitor_iam_members/constraints/to_be_adapted__no_users/readme.md)** (*major* Identity and Access Management)
  - **[to_be_adapted_domains_only](instances/monitor_iam_members/constraints/to_be_adapted_domains_only/readme.md)** (*major* Identity and Access Management)
- sa_key_age   - **[iam_sa_key_age](instances/monitor_iam_sa_key_age/constraints/iam_sa_key_age/readme.md)** (*medium* Debt Management)

## kms

- rotation   - **[kms_max_rotation_period](instances/monitor_kms_rotation/constraints/kms_max_rotation_period/readme.md)** (*medium* Debt Management)
