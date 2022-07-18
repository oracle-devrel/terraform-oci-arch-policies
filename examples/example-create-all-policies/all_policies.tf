## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


module "example_create_all_policies" {
  #source = "./../../"
  source = "github.com/oracle-devrel/terraform-oci-arch-policies"

  activate_policies_for_service = ["Functions", "OKE", "OpenSearch", "OpenSearchUser", "OpenSearch"]
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  region_name                   = var.region
  release                       = "2.0"
  random_id                     = "PW30"
}
