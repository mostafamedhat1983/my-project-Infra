resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw_name
  }
}

locals {
  nat_subnets = var.nat_gateway_count == 1 ? {
    "us-east-2a" = var.public_subnets["us-east-2a"]
  } : var.public_subnets
}

resource "aws_eip" "nat" {
  for_each = local.nat_subnets
  domain   = "vpc"
  tags = {
    Name = "${each.value.name}-${each.key}-eip"
  }
}

resource "aws_nat_gateway" "this" {
  for_each      = local.nat_subnets
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${each.value.name}-${each.key}-nat"
  }
}

resource "aws_route_table" "public" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${each.value.name}-${each.key}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0
    nat_gateway_id = var.nat_gateway_count == 1 ? aws_nat_gateway.this["us-east-2a"].id : aws_nat_gateway.this[each.value.availability_zone].id
  }

  tags = {
    Name = "${each.value.name}-${each.key}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = var.sg_name
  }
}

resource "aws_security_group_rule" "this" {
  for_each = var.sg_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  security_group_id = aws_security_group.this.id
  description = each.value.description
}