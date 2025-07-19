output "role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.this.id
}

output "instance_profile_name" {
  description = "The name of the instance profile"
  value       = aws_iam_instance_profile.this.name
}
