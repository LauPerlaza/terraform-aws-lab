
output "vpc1" {
  value = module.vpc1.id
}

output "vpc2" {
  value = module.vpc2.id
}

output "cidr_block_vpc1" {
  value = module.vpc1.cidr_block
}

output "cidr_block_vpc2" {
  value = module.vpc2.cidr_block
}

output "route_table_id_1" {
  value = aws_route_table.route_table_vpc1.id
}

output "route_table_id_2" {
  value = aws_route_table.route_table_vpc2.id
}

output "sgroup_ec2" {
  value = aws_security_group.sgroup_ec2.id
}