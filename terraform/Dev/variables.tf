variable "subnet_config" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "public_subnet_1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-2a"
    }
    "public_subnet_2" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-2b"
    }
  }
}