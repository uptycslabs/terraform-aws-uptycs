
module "cspm-config" {
  source = "../../modules/cspm_integration"

  role_name                       = var.role_name
  upt_account_id                  = var.upt_account_id
  external_id                     = var.external_id
  permissions_boundary_policy_arn = var.permissions_boundary_policy_arn
  tags                            = var.tags

}

output "aws_parameters" {
  value = module.cspm-config.cspm_role_details
}

