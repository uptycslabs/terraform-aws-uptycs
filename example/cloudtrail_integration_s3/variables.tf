

variable "role_name" {
  description = "Name of the new role for Uptycs cloudtrail Integration"
  type        = string
  default     = "UptycsIntegration-cloudtrailS3"
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
  default     = ["dummybucket"]
}

variable "cloudtrail_kinesis_stream_arns_list" {
  description = "List of kinesis stream arns used in inline policy resource"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = { "cloudtrailIntegrationType" : "S3" }
}


# variable "role_name" {
#   description = "Name of the new role for Uptycs cloudtrail Integration"
#   type        = string
#   default     = "UptycsIntegration-cloudtrail"
# }

# variable "upt_account_id" {
#   description = "Uptycs AWS account ID"
#   type        = string
# }

# variable "external_id" {
#   description = "Role Trust Relationship STS condition string(UUID)"
#   type        = string
# }

# variable "permissions_boundary_policy_arn" {
#   description = "Permissions Boundary Arn for Attaching to new Role"
#   type        = string
#   default     = ""
# }


# variable "cloudtrail_bucket_names_list" {
#   description = "List of bucket Names used in inline policy resource"
#   type        = list(string)
#   default     = []
# }

# variable "cloudtrail_kinesis_stream_arns_list" {
#   description = "List of kinesis stream arns used in inline policy resource"
#   type        = list(string)
#   default     = []
# }


# variable "tags" {
#   description = "Tags to apply to the resources created by this module"
#   type        = map(string)
#   default     = {}
# }
