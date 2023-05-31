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
      "*"
    ]
  }
}