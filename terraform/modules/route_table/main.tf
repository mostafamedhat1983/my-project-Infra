resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.subnets_to_associate
  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}