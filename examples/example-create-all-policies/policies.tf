## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "random_id" "tag" {
  byte_length = 2
}

module "example_create_all_policies" {
  source                        = "github.com/oracle-devrel/terraform-oci-arch-policies"
  providers                     = { oci = oci.homeregion }
  activate_policies_for_service = ["Functions", "OKE", "OpenSearch", "OpenSearchUser"]
  tenancy_ocid                  = var.tenancy_ocid
  policy_compartment_ocid       = var.compartment_ocid
  random_id                     = "${random_id.tag.hex}"
  region_name                   = "us-ashburn-1"
  # defined_tags 
}
