resource "random_string" "bucket_name" {
  length  = 4
  special = false
}
resource "aws_s3_bucket" "s3_test" {
  bucket        = "${var.bucket_name}_${random_string.bucket_name.result}"
  force_destroy = true

  tags = {
    Name        = "bucket_test_${var.environment}"
    Environment = var.environment
  }
}
resource "aws_s3_bucket_ownership_controls" "acl_test" {
  bucket = aws_s3_bucket.s3_test.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "acl_test" {
  depends_on = [aws_s3_bucket_ownership_controls.acl_test]
  bucket     = aws_s3_bucket.s3_test.id
  acl        = "private"
}
resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3_test.id
  versioning_configuration {
    status = var.versioning_status ? "Enabled" : "Suspended"
  }
}
resource "aws_s3_bucket_policy" "s3_policy" {
  count  = var.enable_bucket_policy == true ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id
  policy = var.bucket_policy
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_kms" {
  count  = var.encrypt_with_kms == true ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_aes" {
  count  = var.encrypt_with_kms == false ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
