resource "aws_s3_bucket" "backend" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "backend" {
  bucket = aws_s3_bucket.backend.id
  acl    = "private"
  depends_on = [ aws_s3_bucket_ownership_controls.backend ]
}

resource "aws_s3_bucket_ownership_controls" "backend" {
  bucket = aws_s3_bucket.backend.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backend.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "backend" {
  bucket = var.bucket_name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          aws_s3_bucket.backend.arn,
          "${aws_s3_bucket.backend.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        "Principal" : "*"
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket                  = aws_s3_bucket.backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_policy.backend
  ]
}

resource "aws_kms_key" "backend" {
  enable_key_rotation = true
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "allow-all-user",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            data.aws_caller_identity.current.account_id,
            var.root_account_id
          ]
        },
        "Action" : "kms:*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "backend" {
  name          = "alias/s3-terraform"
  target_key_id = aws_kms_key.backend.key_id
}