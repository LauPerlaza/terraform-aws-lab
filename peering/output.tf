output "vpc1_id" {
  value = aws_vpc.vpc1.id
}

output "vpc2_id" {
  value = aws_vpc.vpc2.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}