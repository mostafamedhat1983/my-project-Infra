output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "jenkins_instance_ids" {
  value       = [for instance in module.ec2 : instance.instance_id]
  description = "Jenkins EC2 instance IDs"
}
