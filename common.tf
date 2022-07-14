## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

module "tags" {
  source = "github.com/oracle-devrel/terraform-oci-arch-tags"
  #source = "../terraform-oci-arch-tags"

  tag_namespace    = "terraform-oci-arch-test-name"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  release          = "1.1"
  region           = var.region
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  user_ocid        = var.user_ocid
}
