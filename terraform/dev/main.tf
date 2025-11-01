data "aws_ami" "jenkins" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-*"]
  }
}

module "network" {
  source = "../modules/network"

  vpc_name       = "vpc-dev"
  vpc_cidr_block = "10.0.0.0/16"

  public_subnets  = var.subnet_config
  private_subnets = var.private_subnet_config

  igw_name          = "igw-dev"
  nat_gateway_count = 1
}

module "ec2" {
  source                 = "../modules/ec2"
  for_each               = var.ec2_config
  ami                    = data.aws_ami.jenkins.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = module.network.private_subnet_ids[each.key]
  vpc_security_group_ids = [module.network.jenkins_sg_id]
  tags                   = each.value.tags
  iam_instance_profile   = module.jenkins_role.instance_profile_name
}

resource "aws_iam_policy" "jenkins_eks" {
  name        = "jenkins-eks-access"
  description = "Allow Jenkins to describe EKS clusters for deployment"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["eks:DescribeCluster"]
      Resource = module.eks.cluster_arn
    }]
  })
}

module "jenkins_role" {
  source = "../modules/role"
  name   = "ec2-ssm-ecr-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    aws_iam_policy.jenkins_eks.arn
  ]
}

module "eks_cluster_role" {
  source = "../modules/role"
  name   = "EKS-cluster-role"
  service = "eks.amazonaws.com"
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

module "eks_node_role" {
  source = "../modules/role"
  name   = "EKS-node-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

module "rds" {
  source = "../modules/rds"

  identifier           = "todo-db-dev"
  db_subnet_group_name = "todo-db-subnet-group-dev"
  secret_name          = "todo-db-dev-credentials"

  subnet_ids = [
    module.network.private_subnet_ids["rds-2a"],
    module.network.private_subnet_ids["rds-2b"]
  ]

  vpc_security_group_ids = [module.network.rds_sg_id]

  storage_size   = 20
  storage_type   = "gp3"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  multi_az                = false
  backup_retention_period = 1
  skip_final_snapshot     = true

  tags = {
    Name = "todo-db-dev"
  }
}

module "eks" {
  source = "../modules/eks"

  cluster_name        = "todo-app-dev"
  cluster_role_arn    = module.eks_cluster_role.role_arn
  node_role_arn       = module.eks_node_role.role_arn
  jenkins_role_arn    = module.jenkins_role.role_arn
  cluster_version     = "1.34"
  
  subnet_ids = [
    module.network.private_subnet_ids["eks-2a"],
    module.network.private_subnet_ids["eks-2b"]
  ]

  endpoint_private_access = true
  endpoint_public_access  = false

  node_group_name    = "todo-app-dev-nodes"
  node_desired_size  = 2
  node_max_size      = 3
  node_min_size      = 1
  instance_types     = ["t3.small"]
  disk_size          = 20
}
