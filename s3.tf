resource "aws_kms_key" "bucket-kms-key" {
  description             = "This key is used to encrypt objects for the cased-shell bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "cased-shell-storage-"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "cased-shell-storage"
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


# Add the describe-instances policy to the ecs task execution role
resource "aws_iam_role_policy" "bucket-task-role" {
  policy = data.aws_iam_policy_document.iam-policy-document.json
  role   = aws_iam_role.ecs-task-role.0.id
}