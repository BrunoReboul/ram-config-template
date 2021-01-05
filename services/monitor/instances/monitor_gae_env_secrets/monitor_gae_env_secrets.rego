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
package templates.gcp.GCPAppengineEnvSecretConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	exempt_list := lib.get_default(params, "exemptions", [])
	name_whitelist := lib.get_default(params, "name_whitelist", [])
	envname_contains := lib.get_default(params, "name_contains", [])
	envvalue_contains := lib.get_default(params, "value_contains", [])

	asset := input.asset
	asset.asset_type == "appengine.googleapis.com/Version"

	# Check if resource is in exempt list
	# matches := {asset.name} & cast_set(exempt_list)
	# count(matches) == 0

	env_vars := lib.get_default(asset.resource.data, "envVariables", {})
	# trace(sprintf("env_vars: %v", [env_vars]))

	env_vars_not_wl := { e:env_vars[e] | not is_whitelisted(e,name_whitelist)}
	# trace(sprintf("env_vars not wl: %v", [env_vars_not_wl]))

	name_matches_found := [e |  env_vars_not_wl[e] ; contains(lower(e),lower(envname_contains[_]))]
	# trace(sprintf("name_matches_found: %v", [name_matches_found]))

	value_matches_found := [sprintf("%v (reason: %v)", [e,envvalue_contains[v].type]) |  {env_vars[e],envvalue_contains[v]} ; re_match(envvalue_contains[v].regex,env_vars[e])]
	# trace(sprintf("value_matches_found: %v", [value_matches_found]))

	base64_encoded_env_vars := { e: base64.decode(env_vars[e]) | is_base64(env_vars[e]) }
	# trace(sprintf("base64_encoded_env_vars: %v", [base64_encoded_env_vars]))

	value_matches_found_base64 := [sprintf("%v (reason: %v, base64 encoded)", [e,envvalue_contains[v].type]) |  {base64_encoded_env_vars[e],envvalue_contains[v]} ; re_match(envvalue_contains[v].regex,base64_encoded_env_vars[e])]
	# trace(sprintf("value_matches_found_base64: %v", [value_matches_found_base64]))

	all_value_matches_found := array.concat(value_matches_found,value_matches_found_base64)
	# trace(sprintf("all_value_matches_found: %v", [all_value_matches_found]))

	count(name_matches_found)+count(all_value_matches_found) > 0

	message := sprintf("AppEngine version %v has env vars with suspicious name: [%v], with suspicious value: [%v].", [asset.resource.data.name, concat(", ",name_matches_found), concat(", ",all_value_matches_found)])
	metadata := {"resource": asset.name}
}


is_base64(string) {
	pattern := "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"
	re_match(pattern,string) 
}

is_whitelisted(name, name_whitelist) {
	name ==  name_whitelist[_]
}
