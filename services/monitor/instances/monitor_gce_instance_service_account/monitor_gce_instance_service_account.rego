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
package templates.gcp.GCPComputeServiceAccountConstraintV1

import data.validator.gcp.lib as lib


deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	
	mode := lib.get_default(params, "mode", "whitelist")
	match_mode := lib.get_default(params, "match_mode", "exact")
	accounts_filter := lib.get_default(params, "service_accounts", [])

	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Instance"

	trace(sprintf("mode: %v, match_mode: %v, filter: %v", [mode, match_mode, accounts_filter[_]]))

	name := asset.resource.data.name
	serviceAccounts := asset.resource.data.serviceAccounts
	emails := [ serviceAccounts[_].email]
	trace(sprintf("asset_name:%v, sa_emails: %v", [name, emails]))
		
	sa_name_targeted(emails[_],accounts_filter,mode,match_mode)

	message := sprintf("VM %v uses service account: %v.", [name, concat(", ", emails)])
	metadata := {
		"resource": asset.name
		}
}

###########################
# Rule Utilities
###########################
sa_name_targeted(sa_email, accounts_filter, mode, match_mode) {
	mode == "whitelist"
	match_mode == "exact"
	matches := {sa_email} & cast_set(accounts_filter)
	count(matches) == 0
}

sa_name_targeted(sa_email, accounts_filter, mode, match_mode) {
	mode == "blacklist"
	match_mode == "exact"
	matches := {sa_email} & cast_set(accounts_filter)
	count(matches) > 0
}

sa_name_targeted(sa_email, accounts_filter, mode, match_mode) {
	mode == "whitelist"
	match_mode == "regex"
	not re_match_name(sa_email, accounts_filter)
}

sa_name_targeted(sa_email, accounts_filter, mode, match_mode) {
	mode == "blacklist"
	match_mode == "regex"
	re_match_name(sa_email, accounts_filter)
}

re_match_name(name, filters) {
	re_match(filters[_], name)
}