# Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

resource "oci_identity_policy" "api_gateway_access_policy" {
  count = contains(var.activate_policies_for_service, "APIGW") ? 1 : 0

  name           = "api_gateway_access_policy-${var.random_id}"
  description    = "api_gateway_access_policy-${var.random_id}"
  compartment_id = var.policy_compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage api-gateway-family in compartment id ${var.policy_compartment_ocid}",
  "Allow group ${var.policy_for_group} to manage api-gateway-family in compartment id ${var.policy_compartment_ocid}"]
  defined_tags = var.defined_tags
}
