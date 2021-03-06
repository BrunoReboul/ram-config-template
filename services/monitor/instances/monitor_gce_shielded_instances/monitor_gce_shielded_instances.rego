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
package templates.gcp.GCPShieldedInstanceConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)
    refConfig := lib.get_default(params, "shieldedInstanceConfig", [])
    # trace(sprintf("refConfig: %v", [ refConfig]))
    
    asset := input.asset
    asset.asset_type == "compute.googleapis.com/Instance"
    instance := asset.resource.data
    shieldedInstanceConfig := lib.get_default(instance, "shieldedInstanceConfig", {})
    # trace(sprintf("shieldedInstanceConfig: %v", [ shieldedInstanceConfig]))
                


    check_config(shieldedInstanceConfig,refConfig)
    message := sprintf("VM %v is missing Shielded VMs settings.", [instance.name])
    metadata := {"resource": asset.name}
}

check_config (shieldedInstanceConfig,refConfig) {
    count(shieldedInstanceConfig)!=0
    refConfig[key]
    object.get(shieldedInstanceConfig, key, "undef")  != refConfig[key]
}

check_config (shieldedInstanceConfig,refConfig) {
    count(shieldedInstanceConfig)==0
}
