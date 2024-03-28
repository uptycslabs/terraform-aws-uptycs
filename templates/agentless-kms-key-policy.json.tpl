{
    "Version": "2012-10-17",
    "Id": "key-uptycs-side-scanner",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
        %{ for organization_id in organization_ids ~}
        %{ if organization_id != "" && organization_id != "o-xxxxxxxxxx" ~}
         ,
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:RetireGrant",
                "kms:ListGrants",
                "kms:CreateGrant"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "${organization_id}"
                }
            }
        }
        %{ endif ~}
        %{ endfor ~}
    ]
}