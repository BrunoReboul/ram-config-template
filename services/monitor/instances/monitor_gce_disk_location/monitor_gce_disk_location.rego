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
package templates.gcp.GCPComputeZoneConstraintV1

import data.validator.gcp.lib as lib

#####################################
# Find Compute Asset Zone Violations
#####################################
deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

    asset := input.asset
    asset.asset_type == "compute.googleapis.com/Disk"

    # Check if resource is in exempt list
    exempt_list := params.exemptions
    matches := {asset.name} & cast_set(exempt_list)
    trace(sprintf("Exempted if count matches > 0: %v", [count(matches)]))
    count(matches) == 0

# Check that zone is in allowlist/denylist
	target_locations := params.locations
	target_location_match_count(params.mode, desired_count)
    trace(sprintf("desired_count, 1 means deny mode, 0 means allow mode", [desired_count]))

	asset_zone := asset.resource.location
    zone_parts := split(asset_zone, "-")
    region_parts := array.slice(zone_parts,0,2)
    asset_location := concat("-", region_parts)
    trace(sprintf("asset_location: %v", [asset_location]))

	location_matches := {asset_location} & cast_set(target_locations)
    trace(sprintf("count location matches %v", [count(location_matches)]))
	count(location_matches) == desired_count

	message := sprintf("%v is in a disallowed location.", [asset.name])
	metadata := {"location": asset_location}
}

#################
# Rule Utilities
#################

# Determine the overlap between locations under test and constraint
# By default (allowlist), we violate if there isn't overlap
target_location_match_count(mode) = 0 {
	mode != "denylist"
}

target_location_match_count(mode) = 1 {
	mode == "denylist"
}
