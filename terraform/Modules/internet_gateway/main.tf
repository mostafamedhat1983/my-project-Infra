resource "aws_internet_gateway" "this" {
  vpc_id = vpc_id

  tags = {
    Name = "${var.name}_internet_gatway"
  }
}