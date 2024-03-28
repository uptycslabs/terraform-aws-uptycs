{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:CreateTags",
            "Resource": [
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "ForAllValues:StringEquals": {
                    "ec2:CreateAction": [
                        "RunInstances",
                        "CreateVolume"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:StartInstances",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/CreatedBy": "${resource_tag}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances"
            ],
            "Resource": "*",
            "Sid": "AllowScannerLaunchFromLaunchTemplate"
        },
        {
            "Action": [
                "kms:RetireGrant",
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:ListGrants"
            ],
            "Effect": "Allow",
            "Resource": "${apifile_encryption_key_arn}",
            "Sid": "AllowKMSAccessToDecryptApiKey"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "${scanner_iam_role_arn}",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ec2.amazonaws.com"
                }
            }
        }
    ]
}