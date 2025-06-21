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
      name = nat
    }
    "us-east-2b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-2b"
      name = nat
    }
  }
}