## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl



resource "oci_identity_policy" "devopspolicy" {
  count          = contains(var.activate_policies_for_service, "DevOps") ? 1 : 0
  name           = "${var.devops_app_name}_devops-policies${module.tags.random_id}"
  description    = "policy created for devops ${var.devops_app_name}"
  compartment_id = var.compartment_ocid
  statements = ["Allow group ${var.policy_for_group}  to manage devops-family in compartment id ${var.compartment_ocid}",
    "Allow group ${var.policy_for_group}  to manage all-artifacts in compartment id ${var.compartment_ocid}",
    "Allow group ${var.devops_dg_name} to manage instance-agent-command-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to use ons-topics in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to read all-artifacts in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to manage repos in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to use instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name} to read secret-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.devops_dg_name}  to manage generic-artifacts in compartment id ${var.compartment_ocid}"
  ]
}

