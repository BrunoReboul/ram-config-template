package templates.gcp.GCPComputeZoneConstraintV1

import data.validator.gcp.lib as lib

#####################################
# Find Compute Asset Zone Violations
#####################################
deny[{
"msg": message,
"details": metadata,
}] {
constraint := input.constraint
lib.get_constraint_params(constraint, params)

# Verify that resource is Instance or Disk
asset := input.asset
{asset.asset_type} == {asset.asset_type} & {"compute.googleapis.com/Instance", "compute.googleapis.com/Disk"}

# Check if resource is in exempt list
exempt_list := params.exemptions
matches := {asset.name} & cast_set(exempt_list)
count(matches) == 0

# Check that zone is in allowlist/denylist
target_zones := params.zones
asset_zone_tokens := split(asset.resource.data.zone, "/")
asset_zone := asset_zone_tokens[minus(count(asset_zone_tokens), 1)]
zone_matches := {asset_zone} & cast_set(target_zones)
target_zone_match_count(params.mode, desired_count)
count(zone_matches) == desired_count

message := sprintf("%v is in a disallowed zone.", [asset.name])
metadata := {"zone": asset_zone}
}

#################
# Rule Utilities
#################

# Determine the overlap between zones under test and constraint
# By default (allowlist), we violate if there isn't overlap
target_zone_match_count(mode) = 0 {
mode != "denylist"
}

target_zone_match_count(mode) = 1 {
mode == "denylist"
}