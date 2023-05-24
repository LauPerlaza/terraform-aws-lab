#   #   # AWS_VPC #  #   #
resource "aws_vpc" "vpc_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc_test_${var.environment}"
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
#   #   # AWS INTERNET GATEWAY #  #   #
resource "aws_internet_gateway" "igw_test" {
  vpc_id = aws_vpc.vpc_test.id
  tags = {
    Name = "internet_gateway_test_${var.environment}"
  }
}
#   #   # AWS ROUTE TABLE #  #   #
resource "aws_route_table" "route_table_test" { 
  vpc_id = aws_vpc.vpc_test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_test.id
  }
  tags = {
    Name = "route_table_test_${var.environment}"
  }
}
#   #   # AWS ROUTE TABLE ASSOCIATION  #  #   #
resource "aws_route_table_association" "route_table_test" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route_table_test.id
}
#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "security_test" {
  name        = "security_group_test"
  description = "security_group_test"
  vpc_id      = aws_vpc.vpc_test.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security_gruop_test_${var.environment}"
  }
}