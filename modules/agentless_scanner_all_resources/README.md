# Terraform Module for AWS Agentless Integration with Uptycs

This module allows you to integrate an AWS account with Uptycs and creates necessary resources to perform agentless side scanning.

## Usage

```hcl
module "agentless-resources-default-region" {
  source = "uptycslabs/uptycs/aws//modules/agentless_scanner_all_resources"

  resources_prefix           = "UptycsIntegration"
  is_default_region          = true
  organization_id            = "o-xxxxxxxxxx"
  scanner_role_pb_policy_arn = ""
  monitor_role_pb_policy_arn = ""
  additional_tags            = {"executedByUser" : ""}

}
```

## Features

The Agentless integration module performs the following actions:

1. Creates a VPC(virtual private cloud) with IPv4 CIDR 10.0.0.0/16
1. Creates a Subnet with CIDR 10.0.1.0/24 within the newly created VPC
1. Creates an Internet Gateway
1. Creates a Route with Destination 0.0.0.0/0(all IPs) Target as a new Internet gateway
1. Creates a Subnet Association with the above route configuration
1. Creates a scanner security group for new VPC with an outbound rule to allow all IPs and ports and this security group will be used by the Agentless side scanner instance.
1. Creates a KMS key used to encrypt and decrypt the copy of snapshots created in the agentless side scanning process.
1. Creates a scanner instance launch template `<resources_prefix>-agentless-scanner-instance-tpl`.above scanner security group is used in network_interfaces of scanner instance launch template

below actions are performed on is_default_region is set to true,
1. Creates a scanner IAM role `<resources_prefix>-agentless-scanner` and inline policy `UptycsAgentlessScannerPolicy` with permissions to allow certain actions to perform agentless scanning by scanner instance.
1. Creates a scanner IAM instance profile `<resources_prefix>-agentless-scanner-profile` by using an above scanner IAM role name.
1. Creates a monitor IAM role `<resources_prefix>-agentless-monitor` and inline policy `UptycsAgentlessMonitorPolicy` with permissions to allow certain actions to perform scaling up and down the scanner instances.
1. Creates a monitor IAM instance profile `<resources_prefix>-agentless-monitor-profile` by using the above monitor IAM role name.
1. Creates a monitor security group for new VPC with an outbound rule to allow all IPs and ports and this security group will be used by the Agentless monitor instance.
1. Creates a monitor instance launch template `<resources_prefix>-agentless-monitor-instance-tpl`. The above monitor security group is used in network_interfaces of monitor instance launch template
1. Created a monitor autoscaling group `<resources_prefix>-agentless-monitor-instance-tpl` to deploy the
1. All the above resources are tagged with key-value map `{"CreatedBy":"<resources_prefix>-agentless"}`. Resources without names are tagged with additional key-value map `{"Name":"<resources_prefix>-agentless-<resource_type>"}`. any inputs from `additional_tags` will be merged into the above tags.
  Note: `additional_tags` should not contain the key `CreatedBy` or `Name`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name  | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| resources_prefix | prefix used in all resources names | `string` | `UptycsIntegration` | Optional |
| is_default_region | flag used to deploy single region or global resources | `bool` |  | Yes |
| organization_id | organization id of organization | `string` |  | Yes |
| scanner_role_pb_policy_arn | Policy ARNs used to set permission boundary for scanner iam role | `string` | `""`  | Optional |
| monitor_role_pb_policy_arn | Policy ARNs used to set permission boundary for monitor iam role | `string` | `""`  | Optional |
| additional_tags | Map of Tags for created resources | `map(string)` | `{}` | Optional |

### Output

| Name | Description |
| --- | --- |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
