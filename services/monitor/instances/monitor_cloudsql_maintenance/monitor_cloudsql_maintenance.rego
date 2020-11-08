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
package templates.gcp.GCPSQLMaintenanceWindowConstraintV1

import data.validator.gcp.lib as lib

# A violation is generated only when the rule body evaluates to true.
deny[{
    "msg": message,
    "details": metadata,
}] {
    spec := lib.get_default(input.constraint, "spec", "")
    parameters := lib.get_default(spec, "parameters", "")
    exempt_list := lib.get_default(parameters, "exemptions", [])

    # Verify that resource is Cloud SQL instance and is not a first gen
    # Maintenance window is supported only on 2nd generation instances
    asset := input.asset
    asset.asset_type == "sqladmin.googleapis.com/Instance"
    asset.resource.data.backendType != "FIRST_GEN"

    # Check if resource is in exempt list
    matches := {asset.name} & cast_set(exempt_list)
    count(matches) == 0

    # get instance settings
    settings := lib.get_default(asset.resource.data, "settings", {})
    instance_maintenance_window := lib.get_default(settings, "maintenanceWindow", {})
    instance_maintenance_window_day := lib.get_default(instance_maintenance_window, "day", "")
	trace(sprintf("instance_maintenance_window_day: %v", [instance_maintenance_window_day]))    

    # check compliance
    instance_maintenance_window_day == 0 

    message := sprintf("%v missing maintenance window.", [asset.name])
    metadata := {"resource": asset.name}
}

# Rule utilities
get_default_when_empty(value, default_value) = output {
    count(value) != 0
    output := value
}

get_default_when_empty(value, default_value) = output {
    count(value) == 0
    output := default_value
}