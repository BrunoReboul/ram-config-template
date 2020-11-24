# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#Check is cluster is using CoreOs or Not
package templates.gcp.GCPGKEEnableK8sEngineMonitoringConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    asset := input.asset
    asset.asset_type == "container.googleapis.com/Cluster"

    cluster := asset.resource.data
    stackdriver_monitoring_disabled(cluster)

    message := sprintf("Kubernetes Engine monitoring is not enabled in cluster %v.", [asset.name])
    metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
stackdriver_monitoring_disabled(cluster) {
    monitoringService := lib.get_default(cluster, "monitoringService", "none")
    monitoringService != "monitoring.googleapis.com/kubernetes"
}