#Este modulo crea una politica de IAM 
module "policy_test" {
  source      = "./modules/iam_policy"
  region      = var.region
  environment = var.environment
}

#Este modulo crea el networking de la infraestructura 

module "networking_test" {
  source                      = "./modules/networking"
  ip                          = "181.63.51.122/32"
  region                      = var.region
  environment                 = var.environment
  name_vpc                    = "vpc_test"
  cidr_block_vpc              = "10.0.0.0/16"
  cidr_block_subnet_public    = ["10.0.1.0/24", "10.0.2.0/24"]
  cidr_block_subnet_public_db = ["10.0.4.0/24", "10.0.5.0/24"]
  cidr_block_subnet_private   = ["10.0.2.0/24", "10.0.3.0/24"]
}

#Este recurso crea un grupo de seguridad para la instancia de EC2. 
#Dependiendo del módulo "networking_test", 

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

#Este modulo crea una instancia de EC2. 
#Dependiendo de los módulos "aws_security_group.security_group_ec2_test" y "networking_test"

module "ec2_test" {
  depends_on    = [aws_security_group.security_group_ec2_test, module.networking_test]
  source        = "./modules/ec2"
  instance_type = var.environment == "staging" ? "t2.micro" : "t3.micro"
  subnet_id     = module.networking_test.subnet_id_sub_public1
  sg_ids        = [aws_security_group.security_group_ec2_test.id]
  name          = "ec2_test"
  environment   = var.environment
}

#Este bloque de datos recopila 

#información sobre la VPC creada por el módulo "networking_test"
data "aws_vpc" "vpc_cidr" {
  id = module.networking_test.vpc_id
}

#Este modulo crea una instancia de RDS

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

#este modulo crea una KMS.
#Se configura el periodo de ventana de eliminación en 10 días.

module "kms" {
  source                  = "./modules/kms"
  deletion_window_in_days = 10
}

#Este modulo crea un bucket de S3

module "s3_test" {
  source               = "./modules/s3_bucket"
  bucket_name          = "bucket_s3_test"
  environment          = var.environment
  region               = "us-east-1"
  enable_bucket_policy = false
  versioning_status    = false
  encrypt_with_kms     = true
  kms_master_key_id    = module.kms.kms_arn
  bucket_policy        = data.aws_iam_policy_document.s3_policy.json
}

module "dynamondb_test" {
  source = "./modules/dynamodb_table"
  table_name    = "state-lock-tfstate-test"
  read_capacity = 20
  write_capacity = 20
  environment   = "dev"
}