resource "aws_s3_bucket" "s3_test" {
  bucket = "bucket_test"
  force_destroy = true

  tags = {
    Name        = "bucket_test_${var.environment}"
    Environment = "var.environment"
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

