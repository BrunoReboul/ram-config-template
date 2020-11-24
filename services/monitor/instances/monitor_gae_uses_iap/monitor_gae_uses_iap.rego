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
package templates.gcp.GCPAppengineIAPEnabledV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

    asset := input.asset

    # Applies to appengine applications only
    asset.asset_type == "appengine.googleapis.com/Application"
    

	application := asset.resource.data
	enabled := iap_enabled(application)
	enabled == false


    # iap_config := lib.get_default(asset.resource.data, "iap", {})
    # is_enabled := lib.get_default(iap_config, "enabled", false)
    # is_enabled == false
    #asset.resource.data.iap.enabled == false

    message := sprintf("%v has not enabled IAP.", [asset.name])
    metadata := {
        "resource": asset.name        
    }
}


###########################
# Rule Utilities
###########################
iap_enabled(application) = iap_enabled {
	iap_config := lib.get_default(application, "iap", {})
	iap_enabled := lib.get_default(iap_config, "enabled", false)
}
