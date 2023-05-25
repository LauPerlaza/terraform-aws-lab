module "policy_test" {
  source = "./modules/iam_policy"
  region      = var.region
  environment = var.environment
}
module "networking_test" {
  source      = "./modules/networking"
  ip          = "181.63.51.122/32"
  region      = var.region
  environment = var.environment
}
resource "aws_security_group" "security_group_ec2_test" {
  depends_on  = [module.networking_test]
  name        = "security_group_ec2_test"
  description = "aws_security_group_ec2_test"
  vpc_id      = module.networking_test.vpc_id

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
}
module "ec2_test" {
  depends_on    = [aws_security_group.security_group_ec2_test, module.networking_test]
  source        = "./modules/ec2"
  instance_type = var.environment == "staging" ? "t2.micro" : "t3.micro"
  subnet_id     = module.networking_test.subnet_id_sub_public1
  sg_ids        = [aws_security_group.security_group_ec2_test.id]
  name          = "ec2_test"
  environment   = var.environment
}
data "aws_vpc" "vpc_cidr" {
  id = module.networking_test.vpc_id
}
module "rds_test" {
  source            = "./modules/rds"
  environment       = var.environment
  engine            = "mysql"
  engine_version    = "5.7"
  user-name         = "laup"
  multi_az          = var.environment == "prod" ? true : false
  availability_zone = "us-east-1a"
  name              = "rds_test"
  vpc_id            = module.networking_test.vpc_id
  subnet_ids        = [module.networking_test.subnet_id_sub_public1, module.networking_test.subnet_id_sub_public2]
  instance_class    = var.environment == "develop" ? "db.t2.micro" : "db.t2.medium"
  cidr_to_allow     = data.aws_vpc.vpc_cidr.cidr_block
}
resource "aws_s3_bucket_policy" "s3_policy" {
  count = var.enable_bucket_policy ? 1 : 0 
   bucket = aws_s3_bucket.bucket_test.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
resource "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = local.aws_caller_identity
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.bucket_test.arn,
      "${aws_s3_bucket.bucket_test.arn}/*",
    ]
  }
}
resource "aws_kms_key" "key_test" {
  description             = "encrypt_bucket_objects"
  deletion_window_in_days = 10
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
module "s3_test" {
  source           = "./modules/s3_bucket"
  environment      = var.environment
  region           = "us-east-1"
  encrypt_with_kms = var.environment == "develop" ? true : false
  kms_arn          = aws_kms_key.key_test.arn
  versioning_status = var.environment == "develop" ? true : false
}