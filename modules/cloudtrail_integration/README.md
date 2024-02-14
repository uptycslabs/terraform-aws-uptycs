# Terraform module for AWS Cloudtrail Monitoring Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs. So, required AWS cloudtrail events are accessible to CSPM and CIEM applications.

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

1. The Cloudtrail integration module will perform the following actions:
1. Create a new aws Iam role using `role_name` if any of `cloudtrail_bucket_names_list` and `cloudtrail_kinesis_stream_arns_list` are not empty. created with trust relationship policy contains Principal of the value of ` upt_account_id`` and sts condition under string match with UUID of value  `external_id`.
1. Create and attach `ReadS3bucketsPolicy` inline policy to a new role based on input `cloudtrail_bucket_names_list`.
1. Create and attach `SubscribeKinesisStreamPolicy` inline policy to a new role based on input `cloudtrail_kinesis_stream_arns_list`.
1. Attach permission boundary based on input `permissions_boundary_policy_arn`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name                                | Description                                                  | Type           | Default                        | Required |
| ----------------------------------- | ------------------------------------------------------------ | -------------- | ------------------------------ | -------- |
| role_name                           | Name to be used for creating role for cloudtrail integration | `string`       | `UptycsIntegration-cloudtrail` | Optional |
| upt_account_id                      | Uptycs AWS account ID                                        | `string`       | `""`                           | Yes      |
| external_id                         | External ID for STS string equal condition                   | `uuid4`        | `""`                           | Yes      |
| permissions_boundary_policy_arn     | Policy ARNs used to set permission boundary                  | `string`       | `""`                           | Optional |
| cloudtrail_bucket_names_list        | List of cloud trail S3 bucket names                          | `list(string)` | `[]`                           | Optional |
| cloudtrail_kinesis_stream_arns_list | List of cloud trail Kinesis Stream Arns List                 | `list(string)` | `[]`                           | Optional |
| tags                                | Map of Tags for created resources                            | `map(string)`  | `{}`                           | Optional |

### Outputs

| Name           | Description                              |
| -------------- | ---------------------------------------- |
| aws_parameters | AWS parameters (ExternalId and RoleName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
