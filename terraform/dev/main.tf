module "vpc" {
  source = "../modules/VPC"
  cidr_block = "10.0.0.0/16"
  name = "vpc_main"
}

module "public_subnet" {
  source = "../modules/public_subnet"
  for_each = var.subnet_config
  
  vpc_id     = module.vpc.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  name = "${each.value.name}_public_subnet_${each.key}"  
}

module "internet_gateway" {
source = "../modules/internet_gateway"  
vpc_id = module.vpc.vpc_id
name = "main"
}

module "eip" {
source = "../modules/eip"  
for_each = var.subnet_config
name = each.key
}

module "private_subnet" {
source = "../modules/private_subnet"
for_each = var.private_subnet_config  
vpc_id = module.vpc.vpc_id
cidr_block = each.value.cidr_block
availability_zone = each.value.availability_zone
name = "${each.value.name}_private_subnet_${each.value.availability_zone}"
}

module "nat_gateway"{
source = "../modules/nat_gateway"
for_each = var.subnet_config
eip_id = module.eip[each.key].eip_id
public_subnet_id = module.public_subnet[each.key].public_subnet_id
name= each.key
}

module "public_route_table"{
for_each = var.subnet_config
source = "../modules/route_table"
vpc_id = module.vpc.vpc_id
cidr_block = "0.0.0.0/0"
gateway_id = module.internet_gateway.internet_gateway_id
name = "public_route_table_${each.key}"
subnet_id = module.public_subnet[each.key].public_subnet_id
}

module "private_route_table_2a"{

source = "../modules/route_table"
vpc_id = module.vpc.vpc_id
cidr_block = "0.0.0.0/0"
gateway_id = module.nat_gateway["us-east-2a"].nat_gateway_id
name = "private_route_table_us-east-2a"
subnet_id = module.private_subnet["1"].private_subnet_id
}

module "private_route_table_2b"{

source = "../modules/route_table"
vpc_id = module.vpc.vpc_id
cidr_block = "0.0.0.0/0"
gateway_id = module.nat_gateway["us-east-2b"].nat_gateway_id
name = "private_route_table_us-east-2b"
subnet_id = module.private_subnet["2"].private_subnet_id
}
