## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl
# This module is configured based on the documentation at :
## - https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm
## - https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm
## - https://docs.oracle.com/en-us/iaas/Content/Logging/Concepts/searchinglogs.htm#required_permissions_for_searching_logs

resource "oci_identity_policy" "log_groups_and_objects_policies" {
  count = contains(var.activate_policies_for_service, "Logging") ? 1 : 0

  name           = "log_groups_and_objects_policies-${module.tags.random_id}"
  description    = "log_groups_and_objects_policies-${module.tags.random_id} - group interact with opensearch family"
  compartment_id = var.compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage log-groups in compartment id ${var.compartment_ocid}",
    "Allow group ${var.policy_for_group} to manage unified-configuration in compartment id ${var.compartment_ocid}",
  "Allow dynamic-group ${var.logging_dg_name} to use unified-log-content in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "logging_users" {
  count = contains(var.activate_policies_for_service, "Logging") ? 1 : 0

  name           = "logging_users-${module.tags.random_id}"
  description    = "logging_users-${module.tags.random_id} - group interact with opensearch family"
  compartment_id = var.compartment_ocid
  statements = [
    "Allow group ${var.logging_user_group_name} to read log-content in compartment id ${var.compartment_ocid}",
  "Allow group ${var.logging_user_group_name} to read log-groups in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_policy" "logging_users_for_audit" {
  count = contains(var.activate_policies_for_service, "Logging") ? 1 : 0

  name           = "logging_users_for_audit-${module.tags.random_id}"
  description    = "logging_users_for_audit-${module.tags.random_id} - group interact with opensearch family"
  compartment_id = var.compartment_ocid
  statements = [
    "Allow group ${var.logging_user_group_name} to read audit-events  in compartment id ${var.compartment_ocid}",
    "Allow group ${var.logging_user_group_name} to read audit-configuration in compartment id ${var.compartment_ocid}"
  ]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}

resource "oci_identity_policy" "logging_audit" {
  count = contains(var.activate_policies_for_service, "Logging") ? 1 : 0

  name           = "logging_audit-${module.tags.random_id}"
  description    = "logging_audit-${module.tags.random_id} - group interact with opensearch family"
  compartment_id = var.compartment_ocid
  statements = [
    "Allow group ${var.policy_for_group} to manage audit-events  in compartment id ${var.compartment_ocid}",
    "Allow group ${var.policy_for_group} to manage audit-configuration in compartment id ${var.compartment_ocid}"
  ]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}

