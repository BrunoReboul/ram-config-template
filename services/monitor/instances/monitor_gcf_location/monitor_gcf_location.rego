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
package templates.gcp.GCPCloudfunctionLocationConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

    asset := input.asset

    # Applies to GCF only
    asset.asset_type == "cloudfunctions.googleapis.com/CloudFunction"

    # Retrieve the list of allowed locations
    locations := params.locations

    # The asset raises a violation if location_is_valid is evaluated to false
    not location_is_valid(asset, locations)

    message := sprintf("CloudFunction %v is in a disallowed location (%v).", [asset.resource.data.name,asset.resource.location])
    metadata := {
        "resource": asset.name
    }
}

###########################
# Rule Utilities
###########################

location_is_valid(asset, locations) {
    # ensure we have a data object
    resource := asset.resource

    # Retrieve the location
    resource_location := resource.location

    # iterate through the locations
    location := locations[_]

    # the resource location is valid if it matches one of the passed locations
    re_match(location, resource_location)
}
