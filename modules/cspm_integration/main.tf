
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
locals {
  actions = [
    "apigateway:GET",
    "codecommit:GetCommit",
    "codepipeline:ListTagsForResource",
    "ds:ListTagsForResource",
    "ec2:SearchTransitGatewayRoutes",
    "eks:DescribeAddon",
    "eks:DescribeFargateProfile",
    "eks:DescribeIdentityProviderConfig",
    "eks:DescribeNodegroup",
    "eks:DescribeUpdate",
    "eks:ListAddons",
    "eks:ListFargateProfiles",
    "eks:ListIdentityProviderConfigs",
    "eks:ListNodegroups",
    "eks:ListTagsForResource",
    "eks:ListUpdates",
    "elasticfilesystem:DescribeFileSystemPolicy",
    "glacier:DescribeJob",
    "glacier:GetDataRetrievalPolicy",
    "glacier:GetJobOutput",
    "glacier:GetVaultNotifications",
    "glacier:ListJobs",
    "glacier:ListTagsForVault",
    "logs:FilterLogEvents",
    "ram:GetResourceShares",
    "ram:ListResources",
    "s3:GetIntelligentTieringConfiguration",
    "servicecatalog:DescribePortfolio",
    "servicecatalog:DescribeProductAsAdmin",
    "servicecatalog:DescribeProvisioningArtifact",
    "servicecatalog:DescribeServiceAction",
    "servicecatalog:SearchProductsAsAdmin",
    "sns:GetSubscriptionAttributes",
    "ssm:ListCommandInvocations",
    "ce:GetCostAndUsage",
    "redshift-serverless:List*",
    "lambda:GetCodeSigningConfig",
    "lambda:GetFunctionCodeSigningConfig"
  ]
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = local.actions
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  name = var.role_name

  path = "/"
  inline_policy {
    name   = "UptycsReadOnlyPolicy"
    policy = local.policy_document
  }
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


resource "aws_iam_role_policy_attachment" "viewaccesspolicy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "securityauditpolicy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.role.name

}
