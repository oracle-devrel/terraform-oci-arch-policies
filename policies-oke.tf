## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

# OKE Policies -- see readme for explination of the use of count
resource "oci_identity_policy" "OKE_access_policy" {
  count = contains(var.activate_policies_for_service, "OKE") ? 1 : 0

  name           = "OKEAccessPolicy-${var.random_id}"
  description    = "OKEAccessPolicy-${var.random_id} - group manage instance-family"
  compartment_id = var.policy_compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage instance-family in compartment id ${var.policy_compartment_ocid}",
  "Allow group ${var.policy_for_group} to use subnets in compartment id  ${var.policy_compartment_ocid}"]
  defined_tags  = var.defined_tags
  freeform_tags = local.implementation_module
}
