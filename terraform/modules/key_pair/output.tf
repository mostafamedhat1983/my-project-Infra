output "key_pair_name" {
  value = aws_key_pair.this.key_name
}

output "ssm_parameter_name" {
  value = aws_ssm_parameter.private_key.name
}