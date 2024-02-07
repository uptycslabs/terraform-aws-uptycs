# Cloudtrail Integration Project

This example illustrates how to create a `cloudtrail-integration` using kinesis stream for uptycs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name                                | Description                                                  | Type           | Default                                                                                                                      | Required |
| ----------------------------------- | ------------------------------------------------------------ | -------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------- |
| role_name                           | Name to be used for creating role for cloudtrail integration | `string`       | `UptycsIntegration-cloudtrailKinesis`                                                                                        | Optional |
| upt_account_id                      | Uptycs AWS account ID                                        | `string`       |                                                                                                                              | Yes      |
| external_id                         | External ID for STS string equal condition                   | `uuid4`        | `"6bf64888-6e43-4003-9f1b-37181efcf3c2"`                                                                                     | Optional |
| permissions_boundary_policy_arn     | Policy ARNs used to set permission boundary                  | `string`       | `""`                                                                                                                         | Optional |
| cloudtrail_bucket_names_list        | List of cloud trail S3 bucket names                          | `list(string)` | `[]`                                                                                                                         | Optional |
| cloudtrail_kinesis_stream_arns_list | List of cloud trail Kinesis Stream Arns List                 | `list(string)` | `["arn:aws:kinesis:us-east-1:123456789012:stream/log-stream1", "arn:aws:kinesis:us-west-2:123456789012:stream/log-stream2"]` | Optional |
| tags                                | Map of Tags for created resources                            | `map(string)`  | `{ "cloudtrailIntegrationType" : "kinesisStream" }`                                                                          | Optional |

### Outputs

| Name           | Description                                     |
| -------------- | ----------------------------------------------- |
| aws_parameters | AWS parameters (ExternalId and IntegrationName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
