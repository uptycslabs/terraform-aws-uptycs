
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
