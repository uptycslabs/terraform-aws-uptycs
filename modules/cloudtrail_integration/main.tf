
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
