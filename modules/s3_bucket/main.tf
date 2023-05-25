resource "aws_kms_key" "key_test" {
  depends_on = [ module.rds_test, aws_s3_bucket_acl]
  description             = "encrypt_bucket_objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket" "s3_test" {
  bucket = "bucket_test"
  force_destroy = true

  tags = {
    Name        = "bucket_test_${var.environment}"
    Environment = "var.environment"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse" {
  bucket = aws_s3_bucket.bucket_test.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_test
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_ownership_controls" "acl_test" {
  bucket = aws_s3_bucket.acl_test.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "acl_test" {
  bucket = aws_s3_bucket.bucket_test.id 
  acl    = "private" 
}
resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3_test.id
  versioning_configuration {
    status = var.versioning_status
  }
}

