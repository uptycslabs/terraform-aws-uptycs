# Terraform Module for AWS CloudTrail Monitoring Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs, providing access to crucial AWS CloudTrail events for CSPM and CIEM applications.

## Usage

```hcl
module "ct-config" {
  source = "uptycslabs/uptycs/aws//modules/cloudtrail_integration"

  role_name                       = "UptycsIntegration-cloudtrail"
  upt_account_id                  = "123456789012"
  external_id                     = "6bf64888-6e43-4003-9f1b-37181efcf3c2"
  permissions_boundary_policy_arn = ""

  cloudtrail_bucket_names_list = [
    "bucket1",
    "bucket2"
  ]

  cloudtrail_kinesis_stream_arns_list = [
    "arn:aws:kinesis:us-east-1:123456789012:stream/log-stream1",
    "arn:aws:kinesis:us-west-2:123456789012:stream/log-stream2"
  ]
}

output "aws_parameters" {
  value = module.ct-config.cloudtrail_role_details
}
```

## Features

The CloudTrail integration module performs the following actions:

1. Creates a new AWS IAM role using `role_name` if any of `cloudtrail_bucket_names_list` and `cloudtrail_kinesis_stream_arns_list` are not empty. Creates trust relationship policy containing Principal of the value of `upt_account_id`` and an STS condition that matches the UUID value of `external_id`.
1. Creates and attaches the inline policy `ReadS3bucketsPolicy` to the new role based on input `cloudtrail_bucket_names_list`.
1. Creates and attaches the inline policy `SubscribeKinesisStreamPolicy` to the new role based on input `cloudtrail_kinesis_stream_arns_list`.
1. Attaches permission boundary `permissions_boundary_policy_arn` based on input.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name                                | Description                                                  | Type           | Default                        | Required |
| ----------------------------------- | ------------------------------------------------------------ | -------------- | ------------------------------ | -------- |
| role_name                           | Role name for creating role for CloudTrail integration       | `string`       | `UptycsIntegration-cloudtrail` | Optional |
| upt_account_id                      | Uptycs AWS account ID                                        | `string`       | `""`                           | Yes      |
| external_id                         | External ID for STS string equal condition                   | `uuid4`        | `""`                           | Yes      |
| permissions_boundary_policy_arn     | Policy ARNs used to set permission boundary                  | `string`       | `""`                           | Optional |
| cloudtrail_bucket_names_list        | List of CloudTrail S3 bucket names                           | `list(string)` | `[]`                           | Optional |
| cloudtrail_kinesis_stream_arns_list | List of CloudTrail Kinesis Stream ARN                        | `list(string)` | `[]`                           | Optional |
| tags                                | Map of Tags for created resources                            | `map(string)`  | `{}`                           | Optional |

### Outputs

| Name           | Description                              |
| -------------- | ---------------------------------------- |
| aws_parameters | AWS parameters (ExternalId and RoleName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
