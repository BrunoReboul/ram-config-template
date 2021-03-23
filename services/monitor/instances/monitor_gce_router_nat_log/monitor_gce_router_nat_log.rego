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
package templates.gcp.GCPNetworkEnableRouterNATLogsConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	param_filter := lib.get_default(params, "filter", "ALL")

	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Router"
	router := asset.resource.data

	trace(sprintf("router : %v", [router]))
	nats := router.nats[_]
	log_config := lib.get_default(nats, "logConfig", {})

	logs_are_ok(log_config, param_filter)

	message := sprintf("Cloud NAT Gateway of Cloud Router %v has no logs enabled or filter is not %v.", [asset.resource.data.name, param_filter])
	metadata := {"resource": asset.name}
}

logs_are_ok(log_config, param_filter) {
	is_enabled := lib.get_default(log_config, "enable", false)
	filter := lib.get_default(log_config, "filter", "IS_KO")
	is_enabled
	filter != param_filter
}

logs_are_ok(log_config, param_filter) {
	is_enabled := lib.get_default(log_config, "enable", false)
	not is_enabled
}
