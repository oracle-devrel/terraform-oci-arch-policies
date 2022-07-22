## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

resource "oci_identity_policy" "api_gateway_access_policy" {
  count = contains(var.activate_policies_for_service, "APIGW") ? 1 : 0

  name           = "APIGatewayAccessPolicy-${module.tags.random_id}"
  description    = "APIGatewayAccessPolicy-${module.tags.random_id} - group manage  api-gateway-family"
  compartment_id = var.compartment_ocid
  statements     = ["Allow group ${var.policy_for_group} to manage api-gateway-family in compartment id ${var.compartment_ocid}"]
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module
}
