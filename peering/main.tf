module "vpc1" {
  source         = "../modules/networking"
  region = var.region
  environment = var.environment
  ip          = "181.63.51.122/32"
  cidr_block  = "10.20.0.0/16"
  cidr_block_subnet_public = ["10.20.1.0/24", "10.20.2.0/24"]
  cidr_block_subnet_public_db = ["10.20.4.0/24", "10.20.5.0/24"]
  cidr_block_subnet_private = ["10.20.10.0/24", "10.20.20.0/24"]
}

module "vpc2" {
  source         = "../modules/networking"
  region = var.region
  environment = var.environment
  ip          = "181.63.51.122/32"
  cidr_block = "192.168.0.0/16"
  cidr_block_subnet_public = ["192.168.10.0/24", "192.168.20.0/24"]
  cidr_block_subnet_private = ["192.168.30.0/24", "192.168.40.0/24"]
}

resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = module.vpc1.vpc_id.id
  peer_vpc_id = module.vpc2.vpc_id.id
  auto_accept = true
}

resource "aws_route" "route_vpc2" {
  route_table_id            = module.vpc1.route_table_id.id
  destination_cidr_block    = module.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "route_vpc1" {
  route_table_id            = module.vpc2.route_table_id.id
  destination_cidr_block    = module.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}