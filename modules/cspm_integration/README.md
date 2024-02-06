# Terraform module for AWS CSPM Integration with Uptycs

This module allows you to integrate AWS account with Uptycs so required AWS telemetry are accessible to CSPM and CIEM applications.

## Usage

```hcl
module "cspm-config" {
  source = "uptycslabs/uptycs/modules/cspm_integration"


  role_name                       = "UptycsIntegration-cspm"
  upt_account_id                  = "685272795239"
  external_id                     = "6bf64888-6e43-4003-9f1b-37181efcf3c2"
  permissions_boundary_policy_arn = ""
}

output "aws_parameters" {
  value = module.cspm-config.aws_parameters
}
```

## Features

The cspm integration module will perform the following actions:

1. create a new aws iam role using `role_name` with trust relationship policy contains Principal of value of `upt_account_id` and sts condition under string match with UUID of value `external_id`.
1. create and attach `UptycsReadOnlyPolicy` inline policy to new role.
1. attach `policy/job-function/ViewOnlyAccess` aws managed policy to new role.
1. attach `policy/SecurityAudit` aws managed policy to new role.
1. attach permission boundery based on input `permissions_boundary_policy_arn`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name                            | Description                                            | Type          | Default                  | Required |
| ------------------------------- | ------------------------------------------------------ | ------------- | ------------------------ | -------- |
| role_name                       | Name to be used for creating role for cspm integration | `string`      | `UptycsIntegration-cspm` | Optional |
| upt_account_id                  | Uptycs AWS account ID                                  | `string`      | `""`                     | Yes      |
| external_id                     | External ID for STS string equal condition             | `uuid4`       | `""`                     | Yes      |
| permissions_boundary_policy_arn | Policy ARNs used to set permission boundary            | `string`      | `""`                     | Optional |
| tags                            | Map of Tags for created resources                      | `map(string)` | `{}`                     | Optional |

### Outputs

| Name           | Description                                     |
| -------------- | ----------------------------------------------- |
| aws_parameters | AWS parameters (ExternalId and IntegrationName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
