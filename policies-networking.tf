## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

resource "oci_identity_policy" "ManageNetworkFamilyPolicy" {
  count          = contains(var.activate_policies_for_service, "Network") ? 1 : 0
  name           = "ManageNetworkFamilyPolicy"
  description    = "ManageNetworkFamilyPolicy - allow group permissions to manage network"
  compartment_id = var.compartment_ocid
  statements     = ["Allow group ${var.policy_for_group} to manage virtual-network-family in compartment id ${var.compartment_ocid}"]

}
