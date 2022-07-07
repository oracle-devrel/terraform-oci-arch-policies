## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


module "example-create-functions-policies" {
  source                        = "../../terraform-oci-arch-policies"
  activate_policies_for_service = ["Functions"]
  tenancy_ocid                  = var.tenancy_ocid
  policy_compartment_ocid       = var.compartment_ocid
  random_id                     = "PW"
  region_name                   = "us-ashburn-1"
  # defined_tags 
}
