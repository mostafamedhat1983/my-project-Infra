output "vpc_id" {
  value = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "vpc_arn" {
  value = aws_vpc.this.arn
  description = "The arn of the VPC"
}

output "public_subnet_ids" {
  value = { for k, v in aws_subnet.public : k => v.id }
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value = { for k, v in aws_subnet.private : k => v.id }
  description = "The IDs of the private subnets"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
  description = "The ID of the internet gateway"
}

output "nat_gateway_ids" {
  value = { for k, v in aws_nat_gateway.this : k => v.id }
  description = "The IDs of the nat gateways"
}

output "route_table_ids" {
  value = {
    public = { for k, v in aws_route_table.public : k => v.id }
    private = { for k, v in aws_route_table.private : k => v.id }
  }
  description = "The IDs of the route tables"
}

output "security_group_id" {
  value = aws_security_group.this.id
  description = "The ID of the security group"
}

output "eip_ids" {
  value = { for k, v in aws_eip.nat : k => v.id }
  description = "The IDs of the EIPs"
}