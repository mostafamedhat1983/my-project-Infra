output "rds_endpoint" {
  value       = module.rds.db_address
  description = "RDS instance hostname"
}

output "rds_port" {
  value       = module.rds.db_port
  description = "RDS instance port"
}

output "rds_database" {
  value       = module.rds.db_name
  description = "Database name"
}

output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "jenkins_instance_ids" {
  value       = [for instance in module.ec2 : instance.instance_id]
  description = "Jenkins EC2 instance IDs"
}
