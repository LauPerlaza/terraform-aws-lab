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
#   #   # AWS_VPC #  #   #
resource "aws_vpc" "vpc_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc_${var.environment}"
    Environment = "${var.environment}"
  }
}
#   #   # AWS_SUBNETS_PUBLIC #  #   #
resource "aws_subnet" "sub_public1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "sub_public1_${var.environment}"
  }
}
resource "aws_subnet" "sub_public2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "sub_public2_${var.environment}"
  }
}
#   #   # AWS_SUBNETS_PUBLIC_db #  #   #
resource "aws_subnet" "sub_public3_db" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "sub_public3_db_${var.environment}"
  }
}
resource "aws_subnet" "sub_public4_db" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "sub_public4_db_${var.environment}"
  }
}
#   #   # AWS_SUBNETS_PRIVATE #  #   #
resource "aws_subnet" "sub_private1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "sub_private1_${var.environment}"
  }
}
resource "aws_subnet" "sub_private2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "sub_private2_${var.environment}"
  }
}
