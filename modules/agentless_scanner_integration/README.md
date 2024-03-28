# Terraform Module for AWS Agentless Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs and creates necessary resources to perform agentless side scanning.

## Usage

```hcl
module "agentless-config" {
  source = "uptycslabs/uptycs/aws//modules/agentless_scanner_integration"

  resources_prefix = "UptycsIntegration"
  organization_id  = "o-tptxw673re"
  default_region   = "us-east-1"
  scan_regions     = ["us-east-1","us-west-2"]
  additional_tags  = {"executedByUser" : ""}
}
```

## Features

The Agentless integration module performs the following actions:

1. Creates all agentless resources mentioned on [Agentless_Resources](../agentless_scanner_all_resources) for default_region
1. Creates agentless resources mentioned on [Agentless_Resources](../agentless_scanner_all_resources) when `is_default_region` is `false` for other `scan_regions` except for `default_region`
1. All the above resources are tagged with key-value map `{"CreatedBy":"<resources_prefix>-agentless"}`. Resources without names are tagged with additional key-value map `{"Name":"<resources_prefix>-agentless-<resource_type>"}`. any inputs from `additional_tags` will be merged into the above tags.
  Note: `additional_tags` should not contain the key `CreatedBy` or `Name`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name  | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| resources_prefix | prefix used in all resources names | `string` | `UptycsIntegration` | Optional |
| organization_id | organization id of organization | `string` |  | Yes |
| default_region | region used to deploy single region or global resources | `string` |  | Yes |
| scanner_role_pb_policy_arn | Policy ARNs used to set permission boundary for scanner iam role | `string` | `""`  | Optional |
| monitor_role_pb_policy_arn | Policy ARNs used to set permission boundary for monitor iam role | `string` | `""`  | Optional |
| additional_tags | Map of Tags for created resources | `map(string)` | `{}` | Optional |

### Output

| Name | Description |
| --- | --- |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
