module "TerraformExecutionRole" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"
  trusted_role_arns = [
    "arn:aws:iam::${var.root_account_id}:root",
  ]
  create_role         = true
  role_name           = "TerraformExecutionRole"
  role_requires_mfa   = false
  attach_admin_policy = true
}


module "role_terraform_backend_accessor" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"
  trusted_role_arns = [
    data.aws_caller_identity.current.account_id,           # current
    var.root_account_id,                                   # root
  ]
  create_role = true
  role_name         = "terraform-backend-access"
  role_requires_mfa   = false
  custom_role_policy_arns = [
    aws_iam_policy.terraform_backend_access.arn,
  ]
}

# see: https://www.terraform.io/docs/language/settings/backends/s3.html#s3-bucket-permissions
resource "aws_iam_policy" "terraform_backend_access" {
  name        = "terraform-backend-accessor"
  path        = "/"
  description = "Use for access terraform backend bucket."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3ObjectAccess",
        "Effect" : "Allow"
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject", # workspaceの削除に必要
        ]
        "Resource" : ["${aws_s3_bucket.backend.arn}/*"]
      },
      {
        "Sid" : "AllowS3BucketAccess",
        "Effect" : "Allow"
        "Action" : [
          "s3:ListBucket",
        ]
        "Resource" : [aws_s3_bucket.backend.arn]
      },
      {
        "Sid" : "AllowKmsAccess",
        "Action" : [
          "kms:*",
        ]
        "Effect" : "Allow"
        "Resource" : [aws_kms_key.backend.arn]
      },
    ]
  })
}
