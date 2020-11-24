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
#Check is cluster is in the right location or not
package templates.gcp.GKEClusterLocationConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

    asset := input.asset
    asset.asset_type == "container.googleapis.com/Cluster"

    target_locations := params.locations

	asset_zone := asset.resource.location
    zone_parts := split(asset_zone, "-")
    region_parts := array.slice(zone_parts,0,2)
    asset_location := concat("-", region_parts)
    trace(sprintf("asset_location: %v", [asset_location]))

	location_matches := {asset_location} & cast_set(target_locations)
    trace(sprintf("count location matches %v", [count(location_matches)]))
	count(location_matches) == 0

    message := sprintf("Cluster %v is in a disallowed location.", [asset.name])
	metadata := {"location": asset_location}
}