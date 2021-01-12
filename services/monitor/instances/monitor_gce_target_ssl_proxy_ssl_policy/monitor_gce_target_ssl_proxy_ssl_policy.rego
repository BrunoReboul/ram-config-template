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
package templates.gcp.GCPTargetSslProxySslPolicyConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    asset := input.asset
    asset.asset_type == "compute.googleapis.com/TargetSslProxy"
    targetSslProxy := asset.resource.data
    ssl_policy := lib.get_default(targetSslProxy, "sslPolicy", false)
	trace(sprintf("ssl_policy : %v",[ssl_policy]))
    ssl_policy == false

    message := sprintf("Target HTTPS Proxy %v has no SSL Policy.", [targetSslProxy.name])
    metadata := {"resource": asset.name}
}