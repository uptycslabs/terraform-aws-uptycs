

variable "role_name" {
  description = "Name of the new role for Uptycs cloudtrail Integration"
  type        = string
  default     = "UptycsIntegration-cloudtrailKinesis"
}

variable "upt_account_id" {
  description = "Uptycs AWS account ID"
  type        = string
}

variable "external_id" {
  description = "Role Trust Relationship STS condition string(UUID)"
  type        = string
  default     = "6bf64888-6e43-4003-9f1b-37181efcf3c2"
}

variable "permissions_boundary_policy_arn" {
  description = "Permissions Boundary Arn for Attaching to new Role"
  type        = string
  default     = ""
}

variable "cloudtrail_bucket_names_list" {
  description = "List of bucket Names used in inline policy resource"
  type        = list(string)
  default     = []
}

variable "cloudtrail_kinesis_stream_arns_list" {
  description = "List of kinesis stream arns used in inline policy resource"
  type        = list(string)
  default     = ["arn:aws:kinesis:us-east-1:123456789012:stream/log-stream1", "arn:aws:kinesis:us-west-2:123456789012:stream/log-stream2"]
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = { "cloudtrailIntegrationType" : "kinesisStream" }
}

