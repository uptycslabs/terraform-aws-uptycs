# Copyright (c) 2024 Uptycs, Inc.

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
