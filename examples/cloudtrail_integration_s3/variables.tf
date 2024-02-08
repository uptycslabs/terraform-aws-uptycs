# Copyright 2024 uptycs

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
#  THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
