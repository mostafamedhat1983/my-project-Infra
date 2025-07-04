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

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with the route table."
  type        = list(string)
}