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
  policy = data.aws_iam_policy_document.s3_policy.json
}
data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::017333715993:user/laura.perlaza"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.s3_test.arn,
      "${aws_s3_bucket.s3_test.arn}/*",
    ]
  }
}

