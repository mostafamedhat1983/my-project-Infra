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

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "sg_rules" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), null)
    source_security_group_id = optional(string, null)
    description              = string
  }))

  validation {
    condition = alltrue([
      for rule in var.sg_rules :
      (rule.cidr_blocks != null) != (rule.source_security_group_id != null)
    ])
    error_message = "Each rule must specify either cidr_blocks or source_security_group_id, but not both."
  }
}

variable "nat_gateway_count" {
  type        = number
  default     = 1
  description = "Number of NAT gateways to create (1 for dev, 2 for prod)"
}