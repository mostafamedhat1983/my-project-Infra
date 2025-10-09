variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "availability_zone" {
  description = "The availability zone for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID for the EC2 instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
}
