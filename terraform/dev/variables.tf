variable "subnet_config" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name = string
  }))
  default = {
    "us-east-2a" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-2a"
      name = "nat"
    }
    "us-east-2b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-2b"
      name = "nat"
    }
  }
}

variable "private_subnet_config" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name = string
  }))
  default = {
    "1" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-2a"
      name = "jenkins"
    }
    "2" = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-2b"
      name = "jenkins"
    }
    "3" = {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-2a"
      name = "eks"
    }
    "4" = {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-2b"
      name = "eks"
    }
    "5" = {
      cidr_block        = "10.0.7.0/24"
      availability_zone = "us-east-2a"
      name = "rds"
    }
    "6" = {
      cidr_block        = "10.0.8.0/24"
      availability_zone = "us-east-2b"
      name = "rds"
    }
  }
}

variable "ec2_config" {
  type = map(object({
    ami               = string
    instance_type     = string
    availability_zone = string
    tags              = map(string)
  }))
  default = {
    "1" = {
      ami               = "ami-0eb9d6fc9fab44d24"
      instance_type     = "t2.medium"
      availability_zone = "us-east-2a"
      tags              = { Name = "jenkins_main" }
    }
    "2" = {
      ami               = "ami-0eb9d6fc9fab44d24"
      instance_type     = "t2.medium"
      availability_zone = "us-east-2b"
      tags              = { Name = "jenkins_node" }
    }
  }
}