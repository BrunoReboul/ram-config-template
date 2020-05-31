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
