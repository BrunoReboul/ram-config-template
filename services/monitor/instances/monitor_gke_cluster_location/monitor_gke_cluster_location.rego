#Check is cluster is in the right location or not
package templates.gcp.GKEClusterLocationConstraintV1

import data.validator.gcp.lib as lib

deny[{
"msg": message,
"details": metadata,
}] {
constraint := input.constraint
lib.get_constraint_params(constraint, params)
asset := input.asset
asset.asset_type == "container.googleapis.com/Cluster"

cluster_location := asset.resource.data.location
target_location := params.allowed_locations
count({cluster_location} & cast_set(target_location)) == 0

message := sprintf("Cluster %v is not allowed in the specified location", [asset.name])
metadata := {"resource": asset.name}
}