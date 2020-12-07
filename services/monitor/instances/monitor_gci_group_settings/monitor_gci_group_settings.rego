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
package templates.gcp.CIGroupSettingsConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
	lib.get_constraint_params(constraint, params)
    mode := lib.get_default(params, "mode", "whitelist")
	
    # target_match_count(mode, desired_count)
    settingsToCheck := params.settings

    groupEmailMatching := lib.get_default(params.selector, "email", ["**"] )
    groupDescPattern := lib.get_default(params.selector, "description", [".*"])
    groupDescEval := lib.get_default(params.selector, "description_eval", "true")
    # DEBUG
    trace(sprintf("groupEmailMatching : %v", [groupEmailMatching]))
    trace(sprintf("groupDescPattern : %v", [groupDescPattern]))
    trace(sprintf("groupDescEval : %v", [groupDescEval]))

    asset := input.asset
    asset.asset_type == "groupssettings.googleapis.com/groupSettings" # test if asset is a GroupSetting

    groupSettings := asset.resource
    groupEmail := lower(groupSettings.email)
    groupDescription := lib.get_default(groupSettings, "description", "")  
    # DEBUG
    trace(sprintf("groupEmail : %v", [groupEmail]))
    trace(sprintf("groupDescription : %v", [groupDescription]))

    description_matches(groupDescPattern[_],groupDescription, groupDescEval )
    
    glob.match(groupEmailMatching[_] , [".","@"], groupEmail)
        
    trace(sprintf("groupSettings : %v", [groupSettings]))
    trace(sprintf("settingsToCheck : %v", [settingsToCheck]))

	exempt_list := lib.get_default(params, "exemptions", [])

    check_settings(settingsToCheck,groupSettings,mode)

	# Check if resource is in exempt list
	matches := {groupEmail} & cast_set(exempt_list)
	count(matches) == 0

    message := sprintf("Settings for group %v are not compliant.", [groupEmail])
    metadata := {"resource": asset.name}
}


check_settings(groupSettings,settingsToCheck,mode)  {
    mode == "whitelist"
    settingsToCheck[k1] != groupSettings[k2]; k1 == k2
}

check_settings(groupSettings,settingsToCheck,mode)  {
    mode == "blacklist"
    settingsToCheck[k1] == groupSettings[k2]; k1 == k2
}


description_matches (groupDescPattern,groupDescription, groupDescEval) {
    re_match(groupDescPattern, groupDescription)
    groupDescEval == "true"
}


description_matches (groupDescPattern,groupDescription, groupDescEval) {
    not re_match(groupDescPattern, groupDescription)
    groupDescEval == "false"
}


