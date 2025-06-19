resource "aws_nat_gateway" "this" {
  allocation_id = eip_id
  subnet_id     = public_subnet_id

  tags = {
    Name = var.name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = public_subnet_id
}