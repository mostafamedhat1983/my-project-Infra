output "public_subnet_id" {
  value = aws_subnet.public.id
  description = "The ID of the public subnet"
}
