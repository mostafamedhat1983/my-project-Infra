module "vpc" {
  source = "../Modules/VPC"
  cidr_block = "10.0.0.0/16"
  name = "vpc_main"
}

module "public_subnet" {
  source = "../Modules/public_subnet"
  for_each = var.subnet_config
  
  vpc_id     = module.vpc.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  name = "${each.value.name}_public_subnet_${each.key}"
  
}
