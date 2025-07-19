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
subnets_to_associate = {
  (each.key) = module.public_subnet[each.key].public_subnet_id
}
}

module "private_route_table_2a"{
source = "../modules/route_table"
vpc_id = module.vpc.vpc_id
cidr_block = "0.0.0.0/0"
gateway_id = module.nat_gateway["us-east-2a"].nat_gateway_id
name = "private_route_table_us-east-2a"
subnets_to_associate = {
  "1" = module.private_subnet["1"].private_subnet_id, # jenkins in us-east-2a
  "3" = module.private_subnet["3"].private_subnet_id  # eks in us-east-2a
}
}

module "private_route_table_2b"{
source = "../modules/route_table"
vpc_id = module.vpc.vpc_id
cidr_block = "0.0.0.0/0"
gateway_id = module.nat_gateway["us-east-2b"].nat_gateway_id
name = "private_route_table_us-east-2b"
subnets_to_associate = {
  "2" = module.private_subnet["2"].private_subnet_id, # jenkins in us-east-2b
  "4" = module.private_subnet["4"].private_subnet_id  # eks in us-east-2b
}
}

module "key_pair"{
source = "../modules/key_pair" 
name = "mykey"
}

module "ec2" {
  source            = "../modules/ec2"
  for_each          = var.ec2_config
  ami               = each.value.ami
  instance_type     = each.value.instance_type
  availability_zone = each.value.availability_zone
  subnet_id         = module.private_subnet[each.key].private_subnet_id
  tags              = each.value.tags
  iam_instance_profile = module.role.instance_profile_name
}

module "role" {
source            = "../modules/role"  
name = "ec2-ssm-role"
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}