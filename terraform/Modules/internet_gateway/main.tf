resource "aws_internet_gateway" "gw" {
  vpc_id = vpc_id

  tags = {
    Name = "${var.name}_internet_gatway"
  }
}