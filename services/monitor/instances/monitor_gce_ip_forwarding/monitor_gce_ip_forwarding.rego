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
package templates.gcp.GCPComputeIpForwardConstraintV1

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
	match_mode := lib.get_default(params, "match_mode", "exact")
	mode := lib.get_default(params, "mode", "whitelist")
	
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Instance"
	instance := asset.resource.data
	
	# Check if instance is in blacklist/whitelist

	target_instances := lib.get_default(params, "instances", [])
	asset_name := instance.name
	trace(sprintf("asset name:%v, target_instances: %v, mode: %v, match_mode: %v", [asset_name, target_instances, mode, match_mode]))
	instance_name_targeted(asset_name, target_instances, mode, match_mode)
	
	# Check if IP Forwarding is active for the instance
	lib.get_default(instance, "canIpForward", false) == true
	
	message := sprintf("%v is not allowed to have IP forwarding enabled.", [asset_name])
	metadata := {"resource": asset.name}
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
