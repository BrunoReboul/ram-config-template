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
package templates.gcp.CIGroupMembersConstraintV1

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
	lib.get_constraint_params(constraint, params)
    mode := lib.get_default(params, "mode", "whitelist")
    # trace(sprintf("Param mode : %v", [mode]))
	target_match_count(mode, desired_count)

    members := lib.get_default(params, "members", ["**"] )
    # trace(sprintf("Param members : %v", [members]))

    asset := input.asset
    # trace(sprintf("Param asset : %v", [asset]))

    asset.asset_type == "www.googleapis.com/admin/directory/members"

    groupEmailMatching := lib.get_default(params.selector, "email", ["**"] )
    # trace(sprintf("groupEmailMatching : %v", [groupEmailMatching]))
    
    groupMember := asset.resource
    groupEmail := groupMember.groupEmail
    type_set := {"USER", "GROUP"}
    type_set[groupMember.type]
    glob.match(groupEmailMatching[_] , [".","@"], groupEmail)
    memberEmail := groupMember.memberEmail
    # trace(sprintf("Param memberEmail : %v", [memberEmail]))


    # Check if resource is in exempt list
	exempt_list := lib.get_default(params, "exemptions", [])
	matches := {memberEmail} & cast_set(exempt_list)
	count(matches) == 0
    
    matches_found := [r | r = members[_]; glob.match(r, [".","@"], memberEmail)]
	trace(sprintf("Param matches_found : %v", [matches_found]))

    count(matches_found) != desired_count    
        
    message := sprintf("Member %v for group %v is not authorized.", [memberEmail, groupEmail])
    metadata := {"resource": asset.name}
}

target_match_count(mode) = 0 {
	mode == "blacklist"
}

target_match_count(mode) = 1 {
	mode == "whitelist"
}
