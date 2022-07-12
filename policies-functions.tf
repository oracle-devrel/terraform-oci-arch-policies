# Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl


# Functions Policies -- see readme for explination of the use of count
resource "oci_identity_policy" "FunctionsDevelopersManageAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsDevelopersManageAccessPolicy-${var.random_id}"
  description    = "FunctionsDevelopersManageAccessPolicy-${var.random_id}"
  compartment_id = var.policy_compartment_ocid
  statements = ["Allow group  ${var.policy_for_group}  to manage functions-family in compartment id ${var.policy_compartment_ocid}",
  "Allow group Administrators to read metrics in compartment id ${var.policy_compartment_ocid}"]
  defined_tags  = var.defined_tags
  freeform_tags = local.implementation_module
}

resource "oci_identity_policy" "FunctionsDevelopersManageNetworkAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsDevelopersManageNetworkAccessPolicy-${var.random_id}"
  description    = "FunctionsDevelopersManageNetworkAccessPolicy-${var.random_id}"
  compartment_id = var.policy_compartment_ocid
  statements     = ["Allow group  ${var.policy_for_group}  to use virtual-network-family in compartment id ${var.policy_compartment_ocid}"]
  defined_tags   = var.defined_tags
  freeform_tags  = local.implementation_module
}

resource "oci_identity_policy" "FunctionsServiceObjectStorageManageAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsServiceObjectStorageManageAccessPolicy-${var.random_id}"
  description    = "FunctionsServiceObjectStorageManageAccessPolicy-${var.random_id}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service objectstorage-${var.region_name} to manage object-family in tenancy"]
  defined_tags   = var.defined_tags
  freeform_tags  = local.implementation_module
}

# Only create the dynamic group id we're asked to
resource "oci_identity_dynamic_group" "FunctionsServiceDynamicGroup" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  name           = "FunctionsServiceDynamicGroup-${var.random_id}"
  description    = "FunctionsServiceDynamicGroup-${var.random_id}"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.policy_compartment_ocid}'}"
  defined_tags   = var.defined_tags
  freeform_tags  = local.implementation_module

}

# if we're asked to create the dynamic group then this version is used to set the necessary policy
# OTHERWISE we look to the dynamically provided name
resource "oci_identity_policy" "FunctionsServiceDynamicGroupPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") && (var.create_dynamic_groups) ? 1 : 0

  depends_on     = [oci_identity_dynamic_group.FunctionsServiceDynamicGroup]
  name           = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  description    = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.FunctionsServiceDynamicGroup[0].name} to manage all-resources in compartment id ${var.policy_compartment_ocid}"]
  defined_tags   = var.defined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "FunctionsServiceDynamicGroupPolicyParameterized" {
  count = contains(var.activate_policies_for_service, "Functions") && (!var.create_dynamic_groups) && (var.functions_dynamic_group_name != null) ? 1 : 0

  name           = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  description    = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${var.functions_dynamic_group_name} to manage all-resources in compartment id ${var.policy_compartment_ocid}"]
  defined_tags   = var.defined_tags
  freeform_tags  = local.implementation_module

}
