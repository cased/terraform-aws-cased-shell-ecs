resource "aws_kms_key" "bucket-kms-key" {
  description             = "This key is used to encrypt objects for the cased-shell bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${local.base_name}-storage-"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "${local.base_name}-storage"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket-kms-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_user" "bucket-user" {
  name = aws_s3_bucket.bucket.bucket
}

resource "aws_iam_access_key" "bucket-user-iam-access-key" {
  user = aws_iam_user.bucket-user.name
}

data "aws_iam_policy_document" "iam-policy-document" {
  // To properly store objects on an encrypted bucket, the policy needs to
  // authorize permission to generate key data when creating objects.
  statement {
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    resources = [
      aws_kms_key.bucket-kms-key.arn
    ]
  }

  // Certain permissions are needed to access the bucket that cannot be applied
  // to a wildcard path.
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
    ]
  }

  // Restricted set of permissions for creating, reading, and deleting objects.
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:DeleteObject",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
      "s3:ReplicateTags",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "bucket-iam-policy" {
  name = aws_s3_bucket.bucket.bucket
  path = "/"

  policy = data.aws_iam_policy_document.iam-policy-document.json
}

resource "aws_iam_user_policy_attachment" "attach-bucket-iam-policy-to-bucket-user" {
  user       = aws_iam_user.bucket-user.name
  policy_arn = aws_iam_policy.bucket-iam-policy.arn
}

resource "aws_secretsmanager_secret" "access-key-id" {
  name                    = "${local.base_name}-storage/access-key-id"
  description             = "The AWS S3 access key ID for the ${local.base_name}-storage bucket."
  kms_key_id              = aws_kms_key.bucket-kms-key.id
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "access-key-id" {
  secret_id     = aws_secretsmanager_secret.access-key-id.id
  secret_string = aws_iam_access_key.bucket-user-iam-access-key.id
}

resource "aws_secretsmanager_secret" "secret-access-key" {
  name                    = "${local.base_name}-storage/secret-access-key"
  description             = "The AWS S3 secret access key for the ${local.base_name}-storage bucket."
  kms_key_id              = aws_kms_key.bucket-kms-key.id
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "secret-access-key" {
  secret_id     = aws_secretsmanager_secret.secret-access-key.id
  secret_string = aws_iam_access_key.bucket-user-iam-access-key.secret
}
