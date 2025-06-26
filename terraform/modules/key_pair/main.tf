
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
  
  tags = {
    Name = var.key_name
    CreatedBy = "Terraform"
  }
}


resource "aws_ssm_parameter" "private_key" {
  name        = "/keypairs/${var.key_name}/private-key"
  description = "Private key for ${var.key_name}"
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
  
  tags = {
    Name = "Private Key - ${var.key_name}"
  }
}