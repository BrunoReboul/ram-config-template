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
package templates.gcp.GCPGKELegacyAbacConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    asset := input.asset
    asset.asset_type == "container.googleapis.com/Cluster"

    container := asset.resource.data
    enabled := legacy_abac_enabled(container)
    enabled == true

    message := sprintf("%v has legacy ABAC enabled.", [asset.name])
    metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
legacy_abac_enabled(container) = legacy_abac_enabled {
    legacy_abac := lib.get_default(container, "legacyAbac", {})
    legacy_abac_enabled := lib.get_default(legacy_abac, "enabled", false)
}