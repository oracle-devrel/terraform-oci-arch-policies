## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl
# This module is configured based on the documentation at https://docs.oracle.com/en-us/iaas/Content/search-opensearch/Concepts/ociopensearch.htm

resource "oci_identity_policy" "open_search_network_policy" {
  count = contains(var.activate_policies_for_service, ["OpenSearch", "OpenSearchUser"]) ? 1 : 0

  name           = "OpenSearchNetworkPolicy-${module.tags.random_id}"
  description    = "OpenSearchNetworkPolicy-${module.tags.random_id} - allow OpenSearch to interact with networking"
  compartment_id = var.compartment_ocid
  statements = ["Allow service opensearch to manage vnics in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to manage vcns in compartment  id ${var.compartment_ocid}",
    "Allow service opensearch to use subnets in compartment id ${var.compartment_ocid}",
  "Allow service opensearch to use network-security-groups in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}


## Note: open_search_clusters_policy OR open_search_clusters_user_policy is set depending on
## whether the permissions should be group based or user based
resource "oci_identity_policy" "open_search_clusters_policy" {
  count = contains(var.activate_policies_for_service, "OpenSearch") ? 1 : 0

  name           = "OpenSearchClustersPolicy-${module.tags.random_id}"
  description    = "OpenSearchClustersPolicy-${module.tags.random_id} - group interact with opensearch family"
  compartment_id = var.compartment_ocid
  statements = ["Allow group ${var.policy_for_group} to manage opensearch-clusters in compartment id ${var.compartment_ocid}",
  "Allow group ${var.policy_for_group} to manage opensearch-family in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module
}

resource "oci_identity_policy" "open_search_clusters_user_policy" {
  count = contains(var.activate_policies_for_service, "OpenSearchUser") ? 1 : 0

  name           = "OpenSearchClustersUserPolicy-${module.tags.random_id}"
  description    = "OpenSearchClustersUserPolicy-${module.tags.random_id} - user manage OpenSearch policy family"
  compartment_id = var.compartment_ocid
  statements = ["Allow any-user to manage opensearch-clusters in compartment id ${var.compartment_ocid}",
  "Allow any-user to manage opensearch-family in compartment id ${var.compartment_ocid}"]
  defined_tags  = module.tags.predefined_tags
  freeform_tags = local.implementation_module

}
