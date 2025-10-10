variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
} 

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "identifier" {
  description = "The DB instance identifier"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The storage type to be associated with the DB instance"
  type        = string
  default     = "gp3"
}

variable "storage_size" {
  description = "The size of the database storage in gigabytes"
  type        = number
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "engine" {
  description = "The engine type of the database"
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "instance_class" {
  description = "The instance class of the database"
  type        = string
}

variable "username" {
  description = "The username for the database"
  type        = string
}

variable "password" {
  description = "The password for the database"
  type        = string
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for the DB instance"
  type        = number
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}