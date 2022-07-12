# terraform-oci-arch-policies

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-arch-policies)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-arch-policies)

## Introduction
This module is intended to create all the necessary policies needed for a reference architecture.  Which policies that are created are controlled through a switch mechanism - so only those required are created.

The driver for having a policies module is to adopt a DRY approach to defining policies each time we create a new architecture that builds on a common approach.  By having policies within one module we can  gain several benefits:

- It means that the module can be referenced early in the parent terraform we can affect a situation where when applying the Terraform, if policies cant be established to support all the resources, then we don't lose time waiting for the other services before the process fails. i.e fail fast
- If any services require a new policy or are impacted by possible change - we can fix all the dependent Terraform solutions in one place rather than applying the same changes to multiple repositories.

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
- /examples: This folder contains examples of how to use the module

To deploy the policies using this Module with minimal effort use this:

```
module "oci-policies" {
  source                  = "github.com/oracle-devrel/terraform-oci-arch-policies"
  compartment_ocid        = ${var.compartment_ocid}
  tenancy_ocid            = ${var.tenanncy_id}
  policy_compartment_ocid = ${var.policy_compartment_ocid}
  random_id               = ${var.random_id}
  region_name             = ${var.region_name}
  defined_tags            = ${var.defined_tags}
}
```
#### Configuration Description

| Argument                      | Description                                                  |
| ----------------------------- | ------------------------------------------------------------ |
| source                        | The URL location of the module for Terraform to retrieve content |
| activate_policies_for_service | This is a list of the services for which we want to have policies enabled for |
| tenancy_ocid                  | The OCID for the tenancy - needed for creating dynamic group policies |
| policy_compartment_ocid       | The OCID of the compartment that contains the service the policy relates to. It is also the location of where the policy will be placed. |
| policy_for_group              | For policies relating to groups this can be used to name the group. If undefined then the value defaults to Administrators |
| random_id                     | An Id that will mean that the Terraform being reused will not clash with any possible pre-existing deployments being used |
| region_name                   | Name of the region for the policy. Needed for some policies such as storage e.g. *us-ashburn-1* |
| defined_tags                  | Predefined Tags to be associated with each resource created. e.g. linking resources to a single solution |
| create_dynamic_groups         | A boolean flag that is defaulted to true. When set where policies depend upon dynamic groups then the dynamic group will be created using the default names.  If you want to supply your own dynamic group then this needs to be explicitly set to FALSE |
| functions_dynamic_group_name  | The dynamic group name to use for the Functions policies setup. By providing the name it is assumed that the resource already exists. and has been created externally. |



#### PolicyFlags

| Label (activate_policies_for_service) | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| Functions                             | Policies to support OCI Functions                            |
| OKE                                   | Policies for Oracle Kubernetes Engine (OKE)                  |
| OpenSearch                            | Policies needed for the creation of the OpenSearch service.  |
| OpenSearchUser                        | A variant of the OpenSearch policies where rather than attributing group permissions the policies are attributed to any-user |

### Outputs

| Output Name                  | Description                                                  |
| ---------------------------- | ------------------------------------------------------------ |
| functions_dynamic_group_name | if the dynamic group is created with the policies then the name of the group is provided here |

### How Policy Creation is Selected

Terraform does not have constructs such as If or explicit loops. However we can affect a conditional behaviour for an entire by setting a count, which turns the resource into a list creation process. If  the list length is 0 in length then the resource is nolonger going to be created. as a result every resource will start with something like the following:

```
  count = contains(var.activate_policies_for_service, "Functions") ? 1 : 0
```

Note the "Functions" element will be repleaced with the appropriate service name.  If the resource is applicable to multiple services then we can us a variation, of this:

## Notes/Issues

Not all service types are supported and the content of this module will need to be extended over time.

## URLs

* OCI Policy syntax - https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/policysyntax.htm

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 