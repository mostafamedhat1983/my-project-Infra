output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "The private ip of the EC2 instance"
  value       = aws_instance.this.private_ip
}
