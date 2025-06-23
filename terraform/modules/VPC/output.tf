output "vpc_id" {
  value = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "vpc_arn" {
  value = aws_vpc.this.arn
  description = "The arn of the VPC"
}