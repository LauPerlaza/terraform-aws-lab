resource "aws_iam_policy" "policy_test" {
  name        = "policy_test"
  path        = "/"
  description = "policy_test"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
   tags = {
    Name        = "policy_test_${var.environment}"
    Environment = var.environment
    CreatedBy   = "terraform"
  }
}