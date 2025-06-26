output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
  description = "The ID of the nat gateway"
}