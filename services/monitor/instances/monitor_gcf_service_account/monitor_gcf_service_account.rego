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
package templates.gcp.GCPCloudfunctionServiceaccountConstraintV1

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
    # Applies to GCF only
    asset.asset_type == "cloudfunctions.googleapis.com/CloudFunction"

	name := asset.resource.data.name
	serviceAccount := asset.resource.data.serviceAccountEmail
	trace(sprintf("asset name:%v, sa_email: %v, mode: %v, match_mode: %v", [name, serviceAccount, mode, match_mode]))
		
	sa_name_targeted(serviceAccount,accounts_filter,mode,match_mode)

	message := sprintf("CloudFunction %v uses service account: %v.", [name, serviceAccount])
	metadata := {"resource": asset.name}
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
