output "vpc_id" {
  value = module.network.vpc_id
}

output "jenkins_instance_ids" {
  value = { for k, v in module.ec2 : k => v.instance_id }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
