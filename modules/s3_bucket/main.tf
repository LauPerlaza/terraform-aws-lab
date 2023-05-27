locals {
  bucket_name = "bucket_s3_test_${var.bucket_name}"
}
resource "aws_s3_bucket" "s3_test" {
  bucket = local.bucket_name
  force_destroy = true

  tags = {
    Name        = "bucket_test_${var.environment}"
    Environment = var.environment
  }
}
resource "aws_s3_bucket_ownership_controls" "acl_test" {
  bucket = "aws_s3_bucket.${var.bucket_name}.id"
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "acl_test" {
   depends_on = [aws_s3_bucket_ownership_controls.acl_test]
  bucket = "aws_s3_bucket.${var.bucket_name}.id" 
  acl    = "private" 
}
resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = "aws_s3_bucket.${var.bucket_name}.id"
  versioning_configuration {
    status = var.versioning_status
  }
}

