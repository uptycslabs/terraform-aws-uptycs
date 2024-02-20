# Terraform module for AWS CSPM Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs, providing access to crucial AWS telemetry for CSPM and CIEM applications.

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

The CSPM integration module performs the following actions:

1. Creates a new AWS IAM role using `role_name` with trust relationship policy containing Principal of value of `upt_account_id` and an STS condition that matches the UUID value of `external_id`.
1. Creates and attaches the inline policy `UptycsReadOnlyPolicy` to the new role.
1. Attaches the following AWS managed policies to the new role:
   - `policy/job-function`/ViewOnlyAccess`
   - `policy/SecurityAudit`
1. Attaches permission boundary `permissions_boundary_policy_arn` based on input.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name                            | Description                                            | Type          | Default                  | Required |
| ------------------------------- | ------------------------------------------------------ | ------------- | ------------------------ | -------- |
| role_name                       | Role name for creating a role for CSPM integration     | `string`      | `UptycsIntegration-cspm` | Optional |
| upt_account_id                  | Uptycs AWS account ID                                  | `string`      | `""`                     | Yes      |
| external_id                     | External ID for STS string equal condition             | `uuid4`       | `""`                     | Yes      |
| permissions_boundary_policy_arn | Policy ARNs used to set permission boundary            | `string`      | `""`                     | Optional |
| tags                            | Map of Tags for created resources                      | `map(string)` | `{}`                     | Optional |

### Output

| Name           | Description                                     |
| -------------- | ----------------------------------------------- |
| aws_parameters | AWS parameters (ExternalId and IntegrationName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
