## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


module "example_create_all_policies" {
  #source                        = "github.com/oracle-devrel/terraform-oci-arch-policies"
  source                        = "../../terraform-oci-arch-policies"
  activate_policies_for_service = ["Functions", "OKE", "OpenSearch", "OpenSearchUser"]
  tenancy_ocid                  = var.tenancy_ocid
  policy_compartment_ocid       = var.compartment_ocid
  random_id                     = "PW2"
  region_name                   = "us-ashburn-1"
  # defined_tags 
}
