output "db_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "RDS instance endpoint (host:port)"
}

output "db_address" {
  value       = aws_db_instance.this.address
  description = "RDS instance hostname"
}

output "db_port" {
  value       = aws_db_instance.this.port
  description = "RDS instance port"
}

output "db_name" {
  value       = aws_db_instance.this.db_name
  description = "Database name"
}

output "db_instance_id" {
  value       = aws_db_instance.this.id
  description = "RDS instance ID"
}
