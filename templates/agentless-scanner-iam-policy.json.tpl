{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:DescribeInstances",
                "ec2:CreateSnapshot",
                "ec2:CreateVolume",
                "ec2:DescribeAvailabilityZones"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "ec2:CreateTags",
            "Condition": {
                "ForAllValues:StringEquals": {
                    "ec2:CreateAction": [
                        "CreateSnapshot",
                        "CreateVolume"
                    ]
                }
            },
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:*::snapshot/*",
                "arn:aws:ec2:*:*:volume/*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteVolume",
                "ec2:DeleteSnapshot",
                "ec2:DeleteTags",
                "ec2:CreateTags",
                "ec2:StopInstances",
                "ec2:StartInstances",
                "ec2:DetachVolume",
                "ec2:AttachVolume"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/CreatedBy": "${resource_tag}"
                }
            },
            "Effect": "Allow",
            "Resource": "*"
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
            "Resource": "arn:aws:kms:*:*:key/*",
            "Sid": "AllowKMSAccessForEncryptedEBS"
        },
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:*",
            "Sid": "AllowLoggingToCloudWatch"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::*:role/${target_iam_role_name}",
            "Sid": "AllowAssumeRoleForCrossAccountScanning"
        }
    ]
}