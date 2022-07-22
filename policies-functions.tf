## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl


# Functions Policies -- see readme for more of the use of count
resource "oci_identity_policy" "FunctionsDevelopersManageAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id}"
  description    = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements = ["Allow group  ${var.policy_for_group}  to manage functions-family in compartment id ${var.compartment_ocid}",
  "Allow group Administrators to read metrics in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "FunctionsServiceNetworkAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  depends_on     = [oci_identity_policy.FunctionsDevelopersManageNetworkAccessPolicy]
  name           = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id}"
  description    = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service FaaS to use virtual-network-family in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

resource "oci_identity_policy" "FunctionsDevelopersManageNetworkAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsDevelopersManageNetworkAccessPolicy-${module.tags.random_id}"
  description    = "FunctionsDevelopersManageNetworkAccessPolicy-${module.tags.random_id} - group use virtual-network-family"
  compartment_id = var.compartment_ocid
  statements     = ["Allow group  ${var.policy_for_group}  to use virtual-network-family in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

resource "oci_identity_policy" "FunctionsServiceObjectStorageManageAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsServiceObjectStorageManageAccessPolicy-${module.tags.random_id}"
  description    = "FunctionsServiceObjectStorageManageAccessPolicy-${module.tags.random_id} - group manage object-family"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service objectstorage-${var.region_name} to manage object-family in tenancy"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}

# Only create the dynamic group id we're asked to
resource "oci_identity_dynamic_group" "FunctionsServiceDynamicGroup" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  name           = "FunctionsServiceDynamicGroup-${module.tags.random_id}"
  description    = "FunctionsServiceDynamicGroup-${module.tags.random_id} - work with functions"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

# if we're asked to create the dynamic group then this version is used to set the necessary policy
# OTHERWISE we look to the dynamically provided name
resource "oci_identity_policy" "FunctionsServiceDynamicGroupPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  depends_on     = [oci_identity_dynamic_group.FunctionsServiceDynamicGroup]
  name           = "FunctionsServiceDynamicGroupPolicy-${module.tags.random_id}"
  description    = "FunctionsServiceDynamicGroupPolicy-${module.tags.random_id} - dynamic group resources policy"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.FunctionsServiceDynamicGroup[0].name} to manage all-resources in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "FunctionsServiceDynamicGroupPolicyParameterized" {
  count = contains(var.activate_policies_for_service, "Functions") && (!var.create_dynamic_groups) && (var.functions_dynamic_group_name != null) ? 1 : 0

  name           = "FunctionsServiceDynamicGroupPolicy-${module.tags.random_id}"
  description    = "FunctionsServiceDynamicGroupPolicy-${module.tags.random_id} - named dynamic group all resources policy"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${var.functions_dynamic_group_name} to manage all-resources in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "FunctionstoServices" {
  count          = contains(var.activate_policies_for_service, "FunctionstoStreams") && (!var.create_dynamic_groups) && (var.functions_dynamic_group_name != null) ? 1 : 0
  depends_on     = [oci_identity_dynamic_group.FunctionsServiceDynamicGroup]
  name           = "FunctionstoServices-${module.tags.random_id}"
  description    = "FunctionstoServices-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements = ["allow dynamic-group ${oci_identity_dynamic_group.FunctionsServiceDynamicGroup[0].name} to manage all-resources in compartment id ${var.compartment_ocid}",
  "allow dynamic-group ${oci_identity_dynamic_group.FunctionsServiceDynamicGroup[0].name} to use stream-push in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "FunctionsServiceReposAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id}"
  description    = "FunctionsDevelopersManageAccessPolicy-${module.tags.random_id} - group can manage metrics"
  compartment_id = var.compartment_ocid
  statements     = ["Allow service FaaS to read repos in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

  #statements     = ["Allow service FaaS to read repos in tenancy"]

}

resource "oci_identity_policy" "AnyGroupUseFnPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "AnyGroupUseFnPolicy-${module.tags.random_id}"
  description    = "AnyGroupUseFnPolicy-${module.tags.random_id} - group usage"
  compartment_id = var.compartment_ocid
  statements     = ["ALLOW group  ${var.policy_for_group} to use functions-family in compartment id ${var.compartment_ocid} where ALL { request.principal.type= 'ApiGateway' , request.resource.compartment.id = '${var.compartment_ocid}'}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "AnyUserUseFnPolicy" {

  count = contains(var.activate_policies_for_service, "FunctionsUsers") ? 1 : 0

  name           = "AnyUserUseFnPolicy-${module.tags.random_id}"
  description    = "AnyUserUseFnPolicy-${module.tags.random_id} any user use Functions"
  compartment_id = var.compartment_ocid
  statements     = ["ALLOW any-user to use functions-family in compartment id ${var.compartment_ocid} where ALL { request.principal.type= 'ApiGateway' , request.resource.compartment.id = '${var.compartment_ocid}'}"]

  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}
