module "vpc" {
  cidr_block = "10.0.0.0/16"
  source = "../Modules/VPC"
  name = "vpc_main"
}
