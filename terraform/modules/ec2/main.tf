resource "aws_instance" "this" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id
  iam_instance_profile = var.iam_instance_profile

  tags = var.tags
}