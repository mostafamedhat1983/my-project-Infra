module "network" {
  source = "../modules/network"

  vpc_name       = "vpc_main"
  vpc_cidr_block = "10.0.0.0/16"

  public_subnets  = var.subnet_config
  private_subnets = var.private_subnet_config

  igw_name           = "main"
  sg_name            = "default_sg"
  sg_description     = "Default security group"
  sg_rules           = {}
  nat_gateway_count  = 1
}

module "key_pair" {
  source = "../modules/key_pair"
  name   = "mykey"
}

module "ec2" {
  source               = "../modules/ec2"
  for_each             = var.ec2_config
  ami                  = each.value.ami
  instance_type        = each.value.instance_type
  availability_zone    = each.value.availability_zone
  subnet_id            = module.network.private_subnet_ids[each.key]
  tags                 = each.value.tags
  iam_instance_profile = module.role.instance_profile_name
}

module "role" {
  source     = "../modules/role"
  name       = "ec2-ssm-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
