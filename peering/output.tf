output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}