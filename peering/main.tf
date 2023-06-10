module "vpc1" {
  source                      = "../modules/networking"
  region                      = var.region
  environment                 = var.environment
  name                        = "vpc1"
  ip                          = "181.63.51.122/32"
  cidr_block_vpc              = "10.20.0.0/16"
  cidr_block_subnet_public    = ["10.20.1.0/24", "10.20.2.0/24"]
  cidr_block_subnet_public_db = ["10.20.4.0/24", "10.20.5.0/24"]
  cidr_block_subnet_private   = ["10.20.10.0/24", "10.20.20.0/24"]
}

module "vpc2" {
  source                      = "../modules/networking"
  region                      = var.region
  environment                 = var.environment
  name                        = "vpc1"
  ip                          = "181.63.51.122/32"
  cidr_block_vpc              = "192.168.0.0/16"
  cidr_block_subnet_public    = ["192.168.10.0/24", "192.168.20.0/24"]
  cidr_block_subnet_public_db = ["192.168.50.0/24", "192.168.60.0/24"]
  cidr_block_subnet_private   = ["192.168.30.0/24", "192.168.40.0/24"]
}

resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = module.vpc1.vpc_id
  peer_vpc_id = module.vpc2.vpc_id
  auto_accept = true
}

resource "aws_route_table" "route_table_vpc1" {
  vpc_id = module.vpc1.vpc_id
}

resource "aws_route_table" "route_table_vpc2" {
  vpc_id = module.vpc2.vpc_id
}

resource "aws_route" "route_vpc2" {
  route_table_id            = aws_route_table.route_table_vpc1.id
  destination_cidr_block    = module.vpc2.cidr_block_vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "route_vpc1" {
  route_table_id            = aws_route_table.route_table_vpc2.id
  destination_cidr_block    = module.vpc1.cidr_block_vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

module "ec2_1" {
  source        = "../modules/ec2"
  instance_type = "t2.micro"
  subnet_id     = module.vpc1.subnet_id_subnet_public1
  sg_ids        = [aws_security_group.sgroup_ec2.id]
  name          = "ec2_1"
  environment   = var.environment
}

module "ec2_2" {
  source        = "../modules/ec2"
  instance_type = "t2.micro"
  subnet_id     = module.vpc2.subnet_id_subnet_public1
  sg_ids        = [aws_security_group.sgroup_ec2.id]
  name          = "ec2_2"
  environment   = var.environment
}

resource "aws_security_group" "sgroup_ec2" {
  name        = "sgroup_ec2"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc1.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "ping_ec2" {
  depends_on = [module.ec2_1, module.ec2_2]

  provisioner "local-exec" {
    command = "ping -c 4 ${module.ec2_2.private_ip}"
  }
}