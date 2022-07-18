## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at oss.oracle.com/licenses/upl

module "tags" {
  source = "../terraform-oci-arch-tags"
  #source           = "github.com/oracle-devrel/terraform-oci-arch-tags"
  tag_namespace    = "terraform-oci-arch-test-name"
  compartment_ocid = var.compartment_ocid
  release          = var.release
  random_id        = var.random_id # provide the optional value
}
