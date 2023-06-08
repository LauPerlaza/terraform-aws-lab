module "vpc1" {
  source         = "../modules/networking"
  vpc_name       = "vpc1_test"
  cidr_block = "10.1.0.0/16"
  region = var.region
  environment = var.environment
  ip          = "181.63.51.122/32"
}

module "vpc2" {
  source         = "../modules/networking"
  vpc_name       = "vpc2_test"
  cidr_block = "192.168.0.0/16"
  region = var.region
  environment = var.environment
  ip          = "181.63.51.122/32"
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