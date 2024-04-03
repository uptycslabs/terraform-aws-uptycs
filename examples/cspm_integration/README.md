# CSPM Integration Project

This example illustrates how to create a `CSPM-Integration` for Uptycs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Inputs

| Name | Description  | Type | Default| Required |
| ---| --- | --- | --- | --- |
| role_name | Role name for creating role for CloudTrail integration | `string` | `UptycsIntegration-cspm` | Optional |
| upt_account_id | Uptycs AWS account ID | `string` |  | Yes |
| external_id | External ID for STS string equal condition | `uuid4` | `"6bf64888-6e43-4003-9f1b-37181efcf3c2"` | Optional |
| permissions_boundary_policy_arn | Policy ARNs used to set permission boundary | `string` | `""` | Optional |
| tags| Map of Tags for created resources| `map(string)` | `{ "testtag" : "value" }`| Optional |

### Outputs

| Name | Description |
| ---| --- |
| cspm_role_details | AWS parameters (ExternalId and IntegrationName) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
