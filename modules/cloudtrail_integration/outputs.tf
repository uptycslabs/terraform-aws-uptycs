output "cloudtrail_role_details" {
  description = "aws parameters (ExternalId and IntegrationName)"
  value = {
    integrationName = var.role_name
    ExternalId      = var.external_id
  }
}
