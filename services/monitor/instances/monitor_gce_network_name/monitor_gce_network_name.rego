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
package templates.gcp.GCPNetworkDefaultConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)
    mode := lib.get_default(params, "mode", "blacklist")
    network := lib.get_default(params, "name", "default")
    target_match_count(mode, desired_count)

    asset := input.asset
    asset.asset_type == "compute.googleapis.com/Network"

    # Check if resource is in exempt list
    exempt_list := params.exemptions
    matches := {asset.name} & cast_set(exempt_list)
    trace(sprintf("Exempted if count matches > 0: %v", [count(matches)]))
    count(matches) == 0


    
    network_name := asset.resource.data.name
    trace(sprintf("network_name: %v", [network_name]))

    matches_found =  [n | n = params.name[_]; network_name == n]
    trace(sprintf("Violation found  if %v != %v", [desired_count,count(matches)]))
    count(matches_found) != desired_count

    message := sprintf("Network %v is present.", [network_name])
    metadata := {"resource": asset.name}
}


target_match_count(mode) = 0 {
	mode == "blacklist"
}

target_match_count(mode) = 1 {
	mode == "whitelist"
}
