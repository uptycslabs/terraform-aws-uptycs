

variable "role_name" {
  description = "role_name."
  type        = string
  default     = "UptycsIntegration-cloudtrail"
}

variable "upt_account_id" {
  description = "upt_account_id"
  type        = string
  default     = "685272795239"
}

variable "external_id" {
  description = "external_id"
  type        = string
  default     = "6bf64888-6e43-4003-9f1b-37181efcf3c2"
}

variable "permissions_boundary_policy_arn" {
  description = "permissions_boundary_policy_arn"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = { "testtag" : "value" }
}
