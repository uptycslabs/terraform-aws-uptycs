variable "resources_prefix" {
  description = "prefix for all the resource names"
  type        = string
  default     = "UptycsIntegration"
}

variable "is_default_region" {
  description = "set is_default_region true for creation of global or single region resources"
  type        = bool
}

variable "organization_id" {
  description = "organization_id is used in kms resource policy to limit actions with in oraganization"
  type        = string
  validation {
    condition     = can(regex("^o-[a-z0-9]{10,32}$", var.organization_id))
    error_message = "Organization ID must be in the format 'o-XXXXXXXXXXXX' where X is an alphabet or a digit"
  }

}

variable "scanner_role_pb_policy_arn" {
  description = "Permissions Boundary Arn for Attaching to new Role"
  type        = string
  default     = ""
}

variable "monitor_role_pb_policy_arn" {
  description = "Permissions Boundary Arn for Attaching to new Role"
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





