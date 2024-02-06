

variable "role_name" {
  description = "role_name."
  type        = string
  default     = "UptycsIntegration-cloudtrail"
}

variable "upt_account_id" {
  description = "upt_account_id"
  type        = string
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

variable "cloudtrail_bucket_names_list" {
  description = "cloudtrail_bucket_names_list"
  type        = list(string)
  default     = ["bucket1", "bucket2"]
}

variable "cloudtrail_kinesis_stream_arns_list" {
  description = "cloudtrail_kinesis_stream_arns_list"
  type        = list(string)
  default     = ["arn:aws:kinesis:us-east-1:123456789012:stream/log-stream1", "arn:aws:kinesis:us-west-2:123456789012:stream/log-stream2"]
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = { "testtag" : "value" }
}
