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

    exempt_list := lib.get_default(params, "exemptions", [])
    settingsToCheck := params.settings
    settingsMode := lib.get_default(params, "settings_mode", "whitelist")

    groupEmailMatching := lib.get_default(params.group_selector, "email", ["**"] )
    groupEmailMode := lib.get_default(params.group_selector, "email_mode", "whitelist" )
    groupDescPattern := lib.get_default(params.group_selector, "description", [".*"])
    groupDescMode := lib.get_default(params.group_selector, "description_mode", "whitelist")
    # DEBUG
	trace(sprintf("settingsMode : %v", [settingsMode]))
    trace(sprintf("groupEmailMatching : %v", [groupEmailMatching]))
    trace(sprintf("groupEmailMode : %v", [groupEmailMode]))
    trace(sprintf("groupDescPattern : %v", [groupDescPattern]))
    trace(sprintf("groupDescMode : %v", [groupDescMode]))

    asset := input.asset
    asset.asset_type == "groupssettings.googleapis.com/groupSettings" # test if asset is a GroupSetting


    # get group infos
    groupSettings := asset.resource
    groupEmail := lower(groupSettings.email)
    groupDescription := lib.get_default(groupSettings, "description", "")  
    trace(sprintf("groupEmail : %v", [groupEmail]))
    trace(sprintf("groupDescription : %v", [groupDescription]))

    # Check if resource is in exempt list 
	matches := {groupEmail} & cast_set(exempt_list)
	count(matches) == 0

    # Keep or reject group based on group email    
    groupEmailMatches := [ groupEmail | glob.match(groupEmailMatching[_] , [".","@"], groupEmail)]
    trace(sprintf("groupEmailMatches : %v", [groupEmailMatches]))
    count(groupEmailMatches) == target_match_count(groupEmailMode)
    
    # Keep or reject group based on group description    
    groupDescMatches := [groupDescription |  re_match(groupDescPattern[_], groupDescription) ]
    trace(sprintf("groupDescMatches : %v", [groupDescMatches]))
    count(groupDescMatches) == target_match_count(groupDescMode)
  
    # check group settings
    check_settings(settingsToCheck,groupSettings,settingsMode)
    
    trace(sprintf("groupSettings : %v", [groupSettings]))
    trace(sprintf("settingsToCheck : %v", [settingsToCheck]))


    message := sprintf("Group %v settings are not compliant.", [groupEmail])
    metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################

# Check values for settings
check_settings(groupSettings,settingsToCheck,mode)  {
    mode == "whitelist"
    settingsToCheck[k1] != groupSettings[k2]; k1 == k2
}

check_settings(groupSettings,settingsToCheck,mode)  {
    mode == "blacklist"
    settingsToCheck[k1] == groupSettings[k2]; k1 == k2
}

target_match_count(mode) = 0 {
	mode == "blacklist"
}

target_match_count(mode) = 1 {
	mode == "whitelist"
}
