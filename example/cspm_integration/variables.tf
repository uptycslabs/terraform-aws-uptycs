

variable "role_name" {
  description = "Name of the new role for Uptycs cloudtrail Integration"
  type        = string
  default     = "UptycsIntegration-cspm"
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

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = { "testtag" : "value" }
}
