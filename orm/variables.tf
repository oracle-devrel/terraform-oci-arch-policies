## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
#variable "oci_username" {}
#variable "oci_user_authtoken" {}


variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}
