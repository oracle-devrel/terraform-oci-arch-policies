## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

# OKE Policies -- see readme for explination of the use of count
resource "oci_identity_policy" "OKE_access_policy" {
  count = contains(var.activate_policies_for_service, "OKE") ? 1 : 0

  name           = "OKEAccessPolicy-${module.tags.random_id}"
  description    = "OKEAccessPolicy-${module.tags.random_id} - group manage instance-family"
  compartment_id = var.compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage instance-family in compartment id ${var.compartment_ocid}",
  "Allow group ${var.policy_for_group} to use subnets in compartment id  ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}


resource "oci_identity_dynamic_group" "oke_worker_dynamic_group" {
  count = contains(var.activate_policies_for_service, "OKEDynamic") ? 1 : 0

  compartment_id = var.tenancy_ocid
  description    = "OKEInstancePrincipleDynamicGrp-${module.tags.random_id}-Dynamic group for worker nodes in OKE cluster"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_ocid}', tag.oke-${module.tags.random_id}.autoscaler.value = 'true'}"
  name           = "OKEInstancePrincipleDynamicGrp-${module.tags.random_id}"
  defined_tags   = module.tags.predefined_tags
  freeform_tags  = local.implementation_module

}

resource "oci_identity_policy" "this" {
  count = contains(var.activate_policies_for_service, "OKEDynamic") ? 1 : 0

  compartment_id = var.compartment_ocid
  description    = "Policy to enable OKE cluster autoscaling"
  name           = "oke_autoscaler_instances-${module.tags.random_id}"
  statements = ["Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to manage cluster-node-pools in compartment ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to manage instance-family in compartment ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to use subnets in compartment ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to use vnics in compartment ${var.compartment_ocid}",
  "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to inspect compartments in compartment ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}

resource "oci_identity_policy" "network_policies" {
  count = contains(var.activate_policies_for_service, "OKEDynamic") ? 1 : 0

  compartment_id = var.compartment_ocid
  description    = "Policy to enable OKE cluster autoscaling"
  name           = "oke_autoscaler_networking-${module.tags.random_id}"
  statements = ["Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to use subnets in compartment ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to read virtual-network-family in compartment ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to use vnics in compartment ${var.compartment_ocid}",
  "Allow dynamic-group ${oci_identity_dynamic_group.oke_worker_dynamic_group[0].name} to inspect compartments in compartment ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}
