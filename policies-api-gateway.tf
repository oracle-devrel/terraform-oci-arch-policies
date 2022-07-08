# Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

resource "oci_identity_policy" "APIGatewayAccessPolicy" {
  count = contains(var.activate_policies_for_service, "APIGW") ? 1 : 0

  depends_on     = [oci_identity_dynamic_group.FunctionsServiceDynamicGroup]
  name           = "APIGatewayAccessPolicy-${var.random_id}"
  description    = "APIGatewayAccessPolicy-${var.random_id}"
  compartment_id = var.policy_compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage api-gateway-family in compartment id ${var.policy_compartment_ocid}",
  "Allow group ${var.policy_for_group} to manage api-gateway-family in compartment id ${var.policy_compartment_ocid}"]
  defined_tags = var.defined_tags
}
