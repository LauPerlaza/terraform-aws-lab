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