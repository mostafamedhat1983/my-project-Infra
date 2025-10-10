module "network" {
  source = "../modules/network"

  vpc_name       = "vpc_main"
  vpc_cidr_block = "10.0.0.0/16"

  public_subnets  = var.subnet_config
  private_subnets = var.private_subnet_config

  igw_name          = "main"
  nat_gateway_count = 1
}

module "ec2" {
  source                 = "../modules/ec2"
  for_each               = var.ec2_config
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = module.network.private_subnet_ids[each.key]
  vpc_security_group_ids = [module.network.jenkins_sg_id]
  tags                   = each.value.tags
  iam_instance_profile   = module.role.instance_profile_name
}

module "role" {
  source     = "../modules/role"
  name       = "ec2-ssm-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "rds" {
  source = "../modules/rds"

  identifier             = "todo-db-dev"
  db_subnet_group_name   = "todo-db-subnet-group-dev"
  
  subnet_ids = [
    module.network.private_subnet_ids["5"],
    module.network.private_subnet_ids["6"]
  ]
  
  vpc_security_group_ids = [module.network.rds_sg_id]
  
  storage_size           = 20
  storage_type           = "gp3"
  db_name                = "todo_db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  
  username               = "root"
  password               = "password"
  
  multi_az                = false
  backup_retention_period = 1
  skip_final_snapshot     = true
  
  tags = {
    Name = "todo-db-dev"
  }
}
