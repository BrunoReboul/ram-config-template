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
package templates.gcp.GCPGKEContainerOptimizedOSConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    asset := input.asset
    asset.asset_type == "container.googleapis.com/Cluster"

    cluster := asset.resource.data
    node_pools := lib.get_default(cluster, "nodePools", [])
    node_pool := node_pools[_]
    non_cos_image(node_pool)

    message := sprintf("Cluster %v has node pool %v without Container-Optimized OS.", [asset.name, node_pool.name])
    metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
non_cos_image(node_pool) {
    nodeConfig := lib.get_default(node_pool, "config", {})
    imageType := lib.get_default(nodeConfig, "imageType", "")
    imageType != "COS"
}