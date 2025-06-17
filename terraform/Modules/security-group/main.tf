resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "this" {
  for_each = var.rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  security_group_id = aws_security_group.this.id
  description = each.value.description
}