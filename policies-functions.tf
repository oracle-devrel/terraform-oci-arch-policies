## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl


# Functions Policies -- see readme for more of the use of count
resource "oci_identity_policy" "functions_developers_manage_access_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "functions_developers_manage_access_policy-${module.tags.random_id}"
  description    = "functions_developers_manage_access_policy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements = ["Allow group  ${var.policy_for_group}  to manage functions-family in compartment id ${var.compartment_ocid}",
  "Allow group Administrators to read metrics in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "functions_service_network_access_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  depends_on     = [oci_identity_policy.function_developers_manage_network_access_policy]
  name           = "functions_service_network_access_policy-${module.tags.random_id}"
  description    = "functions_service_network_access_policy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service FaaS to use virtual-network-family in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

resource "oci_identity_policy" "function_developers_manage_network_access_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "function_developers_manage_network_access_policy-${module.tags.random_id}"
  description    = "function_developers_manage_network_access_policy-${module.tags.random_id} - group use virtual-network-family"
  compartment_id = var.compartment_ocid
  statements     = ["Allow group  ${var.policy_for_group}  to use virtual-network-family in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

resource "oci_identity_policy" "functions_service_object_storage_manage_access_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "functions_service_object_storage_manage_access_policy-${module.tags.random_id}"
  description    = "functions_service_object_storage_manage_access_policy-${module.tags.random_id} - group manage object-family"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service objectstorage-${var.region_name} to manage object-family in tenancy"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

# Only create the dynamic group id we're asked to
resource "oci_identity_dynamic_group" "functions_service_dynamic_group" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  name           = "functions_service_dynamic_group-${module.tags.random_id}"
  description    = "functions_service_dynamic_group-${module.tags.random_id} - work with functions"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

# if we're asked to create the dynamic group then this version is used to set the necessary policy
# OTHERWISE we look to the dynamically provided name
resource "oci_identity_policy" "functions_service_dynamic_group_policy" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  depends_on     = [oci_identity_dynamic_group.functions_service_dynamic_group]
  name           = "functions_service_dynamic_group_policy-${module.tags.random_id}"
  description    = "functions_service_dynamic_group_policy-${module.tags.random_id} - dynamic group resources policy"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.functions_service_dynamic_group[0].name} to manage all-resources in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "functions_serviced_dynamic_group_policy_parameterized" {
  count = contains(var.activate_policies_for_service, "Functions") && (!var.create_dynamic_groups) && (var.functions_dynamic_group_name != null) ? 1 : 0

  name           = "functions_serviced_dynamic_group_policy_parameterized-${module.tags.random_id}"
  description    = "functions_serviced_dynamic_group_policy_parameterized-${module.tags.random_id} - named dynamic group all resources policy"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${var.functions_dynamic_group_name} to manage all-resources in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "functions_to_services" {
  count          = contains(var.activate_policies_for_service, "FunctionstoStreams") && (!var.create_dynamic_groups) && (var.functions_dynamic_group_name != null) ? 1 : 0
  depends_on     = [oci_identity_dynamic_group.functions_service_dynamic_group]
  name           = "functions_to_services-${module.tags.random_id}"
  description    = "functions_to_services-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements = ["allow dynamic-group ${oci_identity_dynamic_group.functions_service_dynamic_group[0].name} to manage all-resources in compartment id ${var.compartment_ocid}",
  "allow dynamic-group ${oci_identity_dynamic_group.functions_service_dynamic_group[0].name} to use stream-push in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "functions_service_repos_access_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "functions_service_repos_access_policy-${module.tags.random_id}"
  description    = "functions_service_repos_access_policy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements     = ["Allow service FaaS to read repos in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

  #statements     = ["Allow service FaaS to read repos in tenancy"]

}

resource "oci_identity_policy" "any_group_use_fn_policy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "any_group_use_fn_policy-${module.tags.random_id}"
  description    = "any_group_use_fn_policy-${module.tags.random_id} - group usage"
  compartment_id = var.compartment_ocid
  statements     = ["ALLOW group  ${var.policy_for_group} to use functions-family in compartment id ${var.compartment_ocid} where ALL { request.principal.type= 'ApiGateway' , request.resource.compartment.id = '${var.compartment_ocid}'}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "any_user_use_fn_policy" {

  count = contains(var.activate_policies_for_service, "FunctionsUsers") ? 1 : 0

  name           = "any_user_use_fn_policy-${module.tags.random_id}"
  description    = "any_user_use_fn_policy-${module.tags.random_id} any user use Functions"
  compartment_id = var.compartment_ocid
  statements     = ["ALLOW any-user to use functions-family in compartment id ${var.compartment_ocid} where ALL { request.principal.type= 'ApiGateway' , request.resource.compartment.id = '${var.compartment_ocid}'}"]

  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}
