## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "example-create-functions-policies" {
  #source                         = "./../../"
  source                        = "github.com/oracle-devrel/terraform-oci-arch-policies"
  activate_policies_for_service = ["Functions"]
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  region_name                   = var.region
  tag_namespace                 = "test-policies-function-namespace"
  release                       = "1.6"
  random_id                     = "PW1"
}
