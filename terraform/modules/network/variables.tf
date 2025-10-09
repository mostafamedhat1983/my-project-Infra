variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name = string
  }))
}

variable "igw_name" {
  type = string
}

variable "nat_gateway_count" {
  type        = number
  default     = 1
  description = "Number of NAT gateways to create (1 for dev, 2 for prod)"
}