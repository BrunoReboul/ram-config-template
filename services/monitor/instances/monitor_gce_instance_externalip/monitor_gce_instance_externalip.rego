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
package templates.gcp.GCPComputeExternalIpAccessConstraintV1
            
import data.validator.gcp.lib as lib

###########################
# Find Whitelist/Blacklist Violations
###########################
deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)
    asset := input.asset
    asset.asset_type == "compute.googleapis.com/Instance"

    # Find network access config block w/ external IP
    instance := asset.resource.data
    access_config := instance.networkInterfaces[_].accessConfigs
    count(access_config) > 0

    # Check if instance is in blacklist/whitelist
    match_mode := lib.get_default(params, "match_mode", "exact")
    target_instances := params.instances
    trace(sprintf("asset name:%v, target_instances: %v, mode: %v, match_mode: %v", [asset.name, target_instances, params.mode, match_mode]))

    instance_name_targeted(asset.name, target_instances, params.mode, match_mode)

    message := sprintf("%v is not allowed to have an external IP.", [asset.name])
    metadata := {"access_config": access_config}
}

###########################
# Rule Utilities
###########################
instance_name_targeted(asset_name, instance_filters, mode, match_mode) {
    mode == "whitelist"
    match_mode == "exact"
    matches := {asset_name} & cast_set(instance_filters)
    count(matches) == 0
}

instance_name_targeted(asset_name, instance_filters, mode, match_mode) {
    mode == "blacklist"
    match_mode == "exact"
    matches := {asset_name} & cast_set(instance_filters)
    count(matches) > 0
}

instance_name_targeted(asset_name, instance_filters, mode, match_mode) {
    mode == "whitelist"
    match_mode == "regex"
    not re_match_name(asset_name, instance_filters)
}

instance_name_targeted(asset_name, instance_filters, mode, match_mode) {
    mode == "blacklist"
    match_mode == "regex"
    re_match_name(asset_name, instance_filters)
}

re_match_name(name, filters) {
    re_match(filters[_], name)
}