variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "gateway_id" {
  type = string
}

variable "name" {
  type = string
}

variable "subnets_to_associate" {
  description = "A map of subnets to associate. Keys are for for_each, values are the subnet IDs."
  type        = map(string)
  default     = {}
}