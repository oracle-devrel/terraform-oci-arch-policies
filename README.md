# terraform-oci-arch-policies

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-arch-policies)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-arch-policies)

## Introduction
This module is intended to create all the necessary policies needed for a reference architecture.  Which policies that are created are controlled through a switch mechanism - so only those required are created.

The driver for having a policies module is to adopt a DRY approach to defining policies each time we create a new architecture that builds on a common approach.  By having policies within one module we can  gain several benefits:

- It means that the module can be referenced early in the parent terraform we can affect a situation where when applying the Terraform, if policies cant be established to support all the resources, then we don't lose time waiting for the other services before the process fails. i.e fail fast
- If any services require a new policy or are impacted by possible change - we can fix all the dependent Terraform solutions in one place rather than applying the same changes to multiple repositories.

This module also makes use of the tags module - so simplifying any further setup. But will allow you to pass through overriding values.

## Getting Started
Examples of how to call the module are provided in the /examples folder. The parameters a detailed below.

### Prerequisites
1. Download and install Terraform (v1.0 or later)
2. Download and install the OCI Terraform Provider (v4.4.0 or later)
3. Export OCI credentials. (this refers to the https://github.com/oracle/terraform-provider-oci )
4. The parent (calling) terraform needs to populate all the values identified by the input.tf file, or accept the default value when one is provided.

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created using Terraform, and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support. Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community to pick up infrastructure improvements through a version number bump.

## How to use this Module

Each Module has the following folder structure:

- root: This folder contains the core module. The Terraform files are structured with a naming convention *policies-<servicename>*. With policies that can apply to everything going into *policies-common*.
- /examples: This folder contains examples of how to use the module.

This module can be extended with new policy requirements. BUT policies should not be granted for tenancy level permissions UNLESS that is the only option OCI supports as doing so can remove good quality security / separation of concerns.

In many cases the policies the policies setup are adapted from the outlines the documentation for the service.

To deploy the policies using this Module with minimal effort use this:

```
module "oci-policies" {
  source                        = "github.com/oracle-devrel/terraform-oci-arch-policies"
  compartment_ocid              = ${var.compartment_ocid}
  tenancy_ocid                  = ${var.tenanncy_id}
  policy_compartment_ocid       = ${var.policy_compartment_ocid}
  random_id                     = random_id.tag.hex
  release                       = "2.5.1"
  region_name                   = ${var.region_name}
  activate_policies_for_service = ["OCI", "Functions"]
  policy_for_group              = "MyUserGroup"
  create_dynamic_groups         = true
  functions_dynamic_group_name  = "myAlternativeGroupName"
}
```
#### Configuration Description

| Argument                      | Description                                                  | Used Policies*        |
| ----------------------------- | ------------------------------------------------------------ | --------------------- |
| source                        | The URL location of the module for Terraform to retrieve content |                       |
| activate_policies_for_service | This is a list of the services for which we want to have policies enabled for. The table below describes the acceptable values |                       |
| tenancy_ocid                  | The OCID for the tenancy - needed for creating dynamic group policies |                       |
| compartment_ocid              | The OCID of the compartment that contains the service the policy relates to. It is also the location of where the policy will be placed. |                       |
| policy_for_group              | For policies relating to the group this can be used to setup and manipulate services. If undefined, then the value defaults to Administrators |                       |
| tag_namespace                 | The name to be used in the tag namespace - passed down to the tags module. |                       |
| random_id                     | An Id that will mean that the Terraform being reused will not clash with any possible pre-existing deployments being used - this is optional, if not provided, one is generated |                       |
| release                       | release value to be provided for the tag. Should reflect the release of the full Terraform solution |                       |
| region_name                   | Name of the region for the policy. Needed for some policies such as storage e.g., *us-ashburn-1* |                       |
| create_dynamic_groups         | A boolean flag that is defaulted to true. When set where policies depend upon dynamic groups, then the dynamic group will be created using the default names.  If you want to supply your own dynamic group, then this needs to be explicitly set to FALSE | Functions, OKEDynamic |
| functions_dynamic_group_name  | The dynamic group name to use for the Functions policies setup. By providing the name, it is assumed that the resource already exists, and has been created externally. | Functions             |
| devops_dg_name                | The Dynamic Group identifying the resources needing to manipulate related services as the capacity expands and contracts. | DevOps                |
| devops_app_name               | The name to be associated with the DevOps resource deescription | DevOps                |
| logging_dg_name               | The name of the Dynamic group that that consumes logging resources | Logging               |
| logging_user_group_name       | The user group name that only require sufficient permissions to interact with the ogs. This is expected to be a broader group than those identified via the policy_for_group. The policies will have lower privileges defined. | Logging               |

*If the field is blank then it applies to all policies.

#### PolicyFlags

| Label (activate_policies_for_service) | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| Functions                             | Policies to support OCI Functions                            |
| OKE                                   | Policies for Oracle Kubernetes Engine (OKE)                  |
| OKEDynamic                            | Enhanced version of OKE, which will include the policies needed to allow OKE to dynamically scale |
| OpenSearch                            | Policies are needed for the creation of the OpenSearch service. |
| OpenSearchUser                        | A variant of the OpenSearch policies where rather than attributing group permissions, the policies are attributed to any-user |
|APIGW | Policies to support the use of the OCI API Gateway |
|Network| Sets up policies for using the general Network Family-related policies |
|DevOps| Sets up the policies needed for the use of DevOps resources|
|Logging| Set the policies to allow resources to be created for Logging activities and grant acccess to users needing to use logging services. |


### Outputs

| Output Name                  | Description                                                  |
| ---------------------------- | ------------------------------------------------------------ |
| functions_dynamic_group_name | if the dynamic group is created with the policies, then the name of the group is provided here |
|oke_dynamic_group |Dynamic Group created for OKE compute nodes|
|predefined_tags|The predefined tags are provided through the use of the tags module|
|random_id|The random id used by the tagging module|

### How Policy Creation is Selected

Terraform does not have constructs such as If or explicit loops. However, we can affect a conditional behavior for an entire by setting a count, which turns the resource into a list creation process. If  the list length is 0 in length, then the resource is no longer going to be created. as a result, every resource will start with something like the following:

```
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0
```

Note the "Functions" element will be replaced with the appropriate service name.  If the resource is applicable to multiple services, then we can use a variation, of this:

## Notes/Issues

Not all service types are supported, and the content of this module will need to be extended over time.

## URLs

* OCI Policy syntax - https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/policysyntax.htm

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 