## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "functions_dynamic_group_name" {
  description = "Some policies are dependent on having a dynamic group - if if the module is told to create the dynamic group then the resource is made available here"
  value       = oci_identity_dynamic_group.FunctionsServiceDynamicGroup
}
