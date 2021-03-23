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
package templates.gcp.GCPCloudfunctionRuntimeConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

	# If blackList mode then 0 expected matches, else 1
	mode := lib.get_default(params, "mode", "whitelist")
	target_match_count(mode, desired_count)

    asset := input.asset

    # Applies to GCF only
    asset.asset_type == "cloudfunctions.googleapis.com/CloudFunction"


    # Retrieve the list of runtimes
    runtimes := params.runtimes
    trace(sprintf("Runtimes : %v", [runtimes]))
    runtime := asset.resource.data.runtime
    trace(sprintf("Runtime : %v", [runtime]))
    matches_runtime := [ r | r = runtimes[_]; r == runtime ]
    trace(sprintf("matches : %v", [matches_runtime]))
    trace(sprintf("matches count : %v", [count(matches_runtime)]))
    trace(sprintf("desired count : %v", [desired_count]))
    count(matches_runtime) != desired_count

    message := sprintf("CloudFunction %v uses a disallowed runtime (%v).", [asset.resource.data.name,runtime])
    metadata := {
        "resource": asset.name,
        
    }
}

###########################
# Rule Utilities
###########################

# Determine the overlap between matches under test and constraint
target_match_count(mode) = 0 {
	mode == "blacklist"
}

target_match_count(mode) = 1 {
	mode == "whitelist"
}
