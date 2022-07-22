## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "activate_policies_for_service" {
  type        = list(string)
  description = "List of services where we need to activate policies e.g. if the listy was initialized as activate_policies_for_service = list {'APIGW', 'Functions'} then the polices for these services would be created"
  validation {
    condition     = length(var.activate_policies_for_service) >= 1
    error_message = "List of policies to enable using the  to the policies module not set."
  }
}

variable "compartment_ocid" {
  type        = string
  nullable    = false
  description = "OCID for the compartment the policies should be configured in and applied to"
  validation {
    condition     = length(var.compartment_ocid) > 1
    error_message = "Policy compartment id not provided to the policies module."
  }
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID for the tenancy the policies should be configured in and applied to"
  validation {
    condition     = length(var.tenancy_ocid) > 1
    error_message = "Policy compartment id not provided to the policies module."
  }
}

variable "region_name" {
  type        = string
  description = "name of the region being used"
  validation {
    condition     = length(var.region_name) >= 3
    error_message = "Policy region name not provided to the policies module."
  }
}

variable "policy_for_group" {
  type        = string
  description = "name of the group policies should be granted to when applied"
  default     = "Administrators"
  validation {
    condition     = length(var.policy_for_group) >= 3
    error_message = "The group name to attribute policy privileges to is not valid."
  }
}

variable "create_dynamic_groups" {
  type        = bool
  default     = true
  description = "Some policies depend upon dynamic groups existing. If they haven't been created and this flag is TRUE (default) then the dynamic group will be created. If the dynamic group is created the output variable will include the name"

}

variable "functions_dynamic_group_name" {
  type        = string
  description = "the name of the dynamic group for Functions to be applied to. Existance of the name is interpreted as meaning the DynamicGroup exists"
  nullable    = true
  default     = null
}

# the following are used to setup the tags
variable "release" {
  type        = string
  nullable    = false
  default     = "1.0"
  description = "Reference Architecture Release (OCI Architecture Center) - note this is validated in the tags module"
}

variable "tag_namespace" {
  type        = string
  nullable    = false
  description = "This is the name of this Reference Architecture e.g. cloud-native-mysql-oci"
}

# if you want to explicitly force the random id used in tagging, set this value
variable "random_id" {
  type        = string
  nullable    = true
  default     = null
  description = "Random Id to help ensure name collisions don't occur"
}

variable "devops_dg_name" {
  type        = string
  description = "This identifies the name of the name of the dynamic group for devops processes to have sufficient privileges to operate the devops platform"
  nullable    = true
  default     = null
}


variable "devops_app_name" {
  type        = string
  description = "This identifies the name of the app the devops processes to have been established for"
  nullable    = true
  default     = null
}

variable "logging_dg_name" {
  type        = string
  description = "This identifies the name of the name of the dynamic group for devops processes to have sufficient privileges to operate the devops platform"
  nullable    = true
  default     = null
}

variable "logging_user_group_name" {
  type        = string
  description = "Users performing logging analysis are assumed to not need the same levels of access granted by policies to those users operating the platform"
  nullable    = true
  default     = null
}
