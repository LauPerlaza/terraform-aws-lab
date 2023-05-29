module "policy_test" {
  source      = "./modules/iam_policy"
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
resource "aws_kms_key" "key_test" {
  # count c
  description             = "encrypt_bucket_objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_kms" {
  count = var.encrypt_with_kms == true ? 1 : 0
  bucket = module.s3_test.bucket_id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_test.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_aes" {
  count = var.encrypt_with_kms == true ? 0 : 1 
  bucket = module.s3_test.bucket_id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_test.arn
      sse_algorithm     = "AES256"
    }
  }
}
resource "random_string" "bucket_name" {
  length  = 4
  special = false
}
module "s3_test" {
  source               = "./modules/s3_bucket"
  bucket_name          = "bucket_s3_test_${random_string.bucket_name.result}"
  environment          = var.environment
  region               = "us-east-1"
  enable_bucket_policy = false 
  versioning_status    = false 
}