
variable "organization_id" {
  description = "organization_id is used in kms resource policy to limit actions with in oraganization"
  type        = string
  validation {
    condition     = can(regex("^o-[a-z0-9]{10,32}$", var.organization_id))
    error_message = "Organization ID must be in the format 'o-xxxxxxxxxx' where x is an alphabet or a digit"
  }
}

variable "resources_prefix" {
  description = "prefix for all the resource names"
  type        = string
  default     = "UptycsIntegration"
}

variable "default_region" {
  description = "required to deploy single region resources and global resources"
  type        = string
  validation {
    condition     = contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2"], var.default_region)
    error_message = "default_region should be one of us-east-1, us-east-2, us-west-1, us-west-2"
  }
}

variable "scan_regions" {
  description = "required to deploy resources to scan in the provided list of regions(limited to us-east-1, us-east-2, us-west-1, us-west-2)"
  type        = list(string)
  validation {
    condition     = length(var.scan_regions) > 0
    error_message = "scan_regions cant be empty list"
  }
}

variable "scanner_role_pb_policy_arn" {
  description = "permissions boundary Arn for attaching to new Role assumed by scanner instance"
  type        = string
  default     = ""
}

variable "monitor_role_pb_policy_arn" {
  description = "permissions boundary Arn for attaching to new Role assumed by monitor instance"
  type        = string
  default     = ""
}

variable "additional_tags" {
  description = "additoinal tags apart from keys CreatedBy and Name"
  type        = map(string)
  default     = {}
  validation {
    condition     = !contains([for k in keys(var.additional_tags) : lower(k)], lower("CreatedBy")) && !contains([for k in keys(var.additional_tags) : lower(k)], lower("Name"))
    error_message = "additional_tags should not contain key CreatedBy or Name"
  }
}

