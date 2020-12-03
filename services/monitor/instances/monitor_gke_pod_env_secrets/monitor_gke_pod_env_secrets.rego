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
package templates.gcp.GCPGKEPodEnvSecretConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	name_whitelist := lib.get_default(params, "name_whitelist", [])
	name_contains := lib.get_default(params, "name_contains", [])
	value_contains := lib.get_default(params, "value_contains", [])

	asset := input.asset
	asset.asset_type == "k8s.io/Pod"

	containers := asset.resource.data.spec.containers

	matched_by_name :=  [ sprintf("container '%v' has suspiciously named variables: [%v]",  [containers[e].name, concat(", ", matches_found)]) | matches_found := check_for_name(containers[e],name_contains,name_whitelist) ]
	# trace(sprintf("matched_by_name: %v", [matched_by_name]))
	
	matched_by_value := [ sprintf("container '%v' has suspicious variables: [%v]",  [containers[e].name, concat(", ", matches_found)]) | matches_found := check_for_value(containers[e],value_contains) ]
	# trace(sprintf("matched_by_value: %v", [matched_by_value]))
	
	matched_containers :=  array.concat(matched_by_name,matched_by_value)
	# trace(sprintf("matched_containers: %v", [matched_containers]))
	count(matched_containers) > 0

	message := sprintf("Pod(s) '%v' definition problems: %v.", [asset.resource.data.metadata.name, concat(", ",matched_containers)])
	metadata := {"resource": asset.name}
}

check_for_value(container,value_contains) = matches_found {
	env_vars := lib.get_default(container, "env", [])
	# trace(sprintf("env_vars: %v", [env_vars]))

	matches_found_value = [ sprintf("%v (reason: %v)",[env_vars[e].name, value_contains[v].type])  | re_match(value_contains[v].regex,env_vars[e].value ) ]
	# trace(sprintf("matches_found_value: %v", [matches_found_value]))

	base64_encoded_env_vars := [ {"name": env_vars[e].name , "value": base64.decode(env_vars[e].value) }| is_base64(env_vars[e].value) ]
	# trace(sprintf("base64_encoded_env_vars: %v", [base64_encoded_env_vars]))

	matches_found_base64 = [ sprintf("%v (reason: %v, base64 encoded)",[base64_encoded_env_vars[e].name, value_contains[v].type])  | re_match(value_contains[v].regex,base64_encoded_env_vars[e].value ) ]
	# trace(sprintf("matches_found_base64: %v", [matches_found_base64]))

	matches_found := array.concat(matches_found_value,matches_found_base64)
	
	count(matches_found) > 0
}

check_for_name(container,name_contains,name_whitelist) = matches_found {
	env_vars := lib.get_default(container, "env", [])
	# trace(sprintf("env_vars: %v", [env_vars]))
	
	env_vars_not_wl := [ e | e = env_vars[_]; not is_whitelisted(e.name,name_whitelist) ]
	# trace(sprintf("env_vars_not_wl: %v", [env_vars_not_wl]))

	matches_found = [e.name | e = env_vars_not_wl[_]; env_check_name(e,name_contains[_])]
	# trace(sprintf("matches_founds: %v", [matches_found]))

	count(matches_found) > 0
}

env_check_name(env_var, env_contain) {
	contains(env_var.name,env_contain)

	# check if variable has a value, do not triggger a violation if not.
	env_var.value 
}


is_base64(string) {
	pattern := "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"
	re_match(pattern,string) 
}

is_whitelisted(name, name_whitelist) {
	name =  name_whitelist[_]
}