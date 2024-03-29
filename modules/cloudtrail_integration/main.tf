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

locals {
  cloudtrail_bucket_present         = length(var.cloudtrail_bucket_names_list) > 0 ? 1 : 0
  cloudtrail_kinesis_stream_present = length(var.cloudtrail_kinesis_stream_arns_list) > 0 ? 1 : 0
  cloudtrail_any_config_present     = length(var.cloudtrail_bucket_names_list) + length(var.cloudtrail_kinesis_stream_arns_list) > 0 ? 1 : 0
}

locals {
  cloudtrail_bucket_arns      = [for item in var.cloudtrail_bucket_names_list : "arn:aws:s3:::${item}"]
  cloudtrail_bucket_arns_star = [for item in var.cloudtrail_bucket_names_list : "arn:aws:s3:::${item}/*"]
}

resource "aws_iam_role_policy" "cloudtrail_bucket_inline_policy" {
  count = local.cloudtrail_bucket_present
  name  = "ReadS3bucketsPolicy"
  role  = aws_iam_role.role[0].name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = concat(local.cloudtrail_bucket_arns, local.cloudtrail_bucket_arns_star)
      },
    ],
  })
}

resource "aws_iam_role_policy" "cloudtrail_kinesis_inline_policy" {
  count = local.cloudtrail_kinesis_stream_present
  name  = "SubscribeKinesisStreamPolicy"
  role  = aws_iam_role.role[0].name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for stream_arns in var.cloudtrail_kinesis_stream_arns_list : {
        Effect = "Allow",
        Action = [
          "kinesis:GetShardIterator",
          "kinesis:GetRecords"
        ],
        Resource = [
          "${stream_arns}",
        ],
      }
    ],
  })
}


resource "aws_iam_role" "role" {
  count                = local.cloudtrail_any_config_present
  name                 = var.role_name
  path                 = "/"
  assume_role_policy   = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": "sts:AssumeRole",
		"Principal": {
			"AWS": "${var.upt_account_id}"
		},
		"Condition": {
			"StringEquals": {
				"sts:ExternalId": "${var.external_id}"
			}
		},
		"Effect": "Allow",
		"Sid": ""
	}]
}
EOF
  permissions_boundary = var.permissions_boundary_policy_arn
  tags                 = var.tags
}
