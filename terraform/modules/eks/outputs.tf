output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "node_group_id" {
  value = aws_eks_node_group.this.id
}

output "node_group_status" {
  value = aws_eks_node_group.this.status
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}
