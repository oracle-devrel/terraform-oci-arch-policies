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

}

resource "oci_identity_policy" "FunctionsDevelopersManageNetworkAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  depends_on     = [oci_identity_policy.FunctionsDevelopersManageAccessPolicy]
  name           = "FunctionsDevelopersManageNetworkAccessPolicy-${var.random_id}"
  description    = "FunctionsDevelopersManageNetworkAccessPolicy-${var.random_id}"
  compartment_id = var.policy_compartment_ocid
  statements     = ["Allow group  ${var.policy_for_group}  to use virtual-network-family in compartment id ${var.policy_compartment_ocid}"]

}

resource "oci_identity_policy" "FunctionsServiceObjectStorageManageAccessPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  depends_on     = [oci_identity_policy.FunctionsDevelopersManageNetworkAccessPolicy]
  name           = "FunctionsServiceObjectStorageManageAccessPolicy-${var.random_id}"
  description    = "FunctionsServiceObjectStorageManageAccessPolicy-${var.random_id}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service objectstorage-${var.region_name} to manage object-family in tenancy"]

}

resource "oci_identity_dynamic_group" "FunctionsServiceDynamicGroup" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  name           = "FunctionsServiceDynamicGroup-${var.random_id}"
  description    = "FunctionsServiceDynamicGroup-${var.random_id}"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.policy_compartment_ocid}'}"
  defined_tags   = var.defined_tags
}

resource "oci_identity_policy" "FunctionsServiceDynamicGroupPolicy" {
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0

  depends_on     = [oci_identity_dynamic_group.FunctionsServiceDynamicGroup]
  name           = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  description    = "FunctionsServiceDynamicGroupPolicy-${var.random_id}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.FunctionsServiceDynamicGroup[0].name} to manage all-resources in compartment id ${var.policy_compartment_ocid}"]
  defined_tags   = var.defined_tags
}

