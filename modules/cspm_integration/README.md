# Terraform module for AWS CSPM Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs so that required AWS telemetry is accessible to CSPM and CIEM applications.

## Usage

```hcl
module "cspm-config" {
  source = "uptycslabs/uptycs/aws//modules/cspm_integration"


  role_name                       = "UptycsIntegration-cspm"
  upt_account_id                  = "123456789012"
  external_id                     = "6bf64888-6e43-4003-9f1b-37181efcf3c2"
  permissions_boundary_policy_arn = ""
}

output "aws_parameters" {
  value = module.cspm-config.aws_parameters
}
```

## Features

The CSPM integration module will perform the following actions:

1. Create a new aws Iam role using `role_name` with trust relationship policy containing Principal of value of `upt_account_id` and sts condition under string match with UUID of value `external_id`.
1. Create and attach the `UptycsReadOnlyPolicy` inline policy to a new role.
1. Attach `policy/job-function`/ViewOnlyAccess` AWS managed policy to a new role.
1. Attach `policy/SecurityAudit` AWS managed policy to a new role.
1. Attach permission boundary based on input `permissions_boundary_policy_arn`

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
