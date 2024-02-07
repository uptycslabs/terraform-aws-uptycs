module "ct-config" {
  source = "../../modules/cloudtrail_integration"


  role_name                           = var.role_name
  upt_account_id                      = var.upt_account_id
  external_id                         = var.external_id
  permissions_boundary_policy_arn     = var.permissions_boundary_policy_arn
  cloudtrail_bucket_names_list        = var.cloudtrail_bucket_names_list
  cloudtrail_kinesis_stream_arns_list = var.cloudtrail_kinesis_stream_arns_list
  tags                                = var.tags
}

output "aws_parameters" {
  value = module.ct-config.cloudtrail_role_details
}
