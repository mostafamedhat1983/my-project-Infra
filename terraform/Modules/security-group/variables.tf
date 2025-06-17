variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "rules" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    # we may use cidr block or source security group but not both
    cidr_blocks              = optional(list(string), null)
    source_security_group_id = optional(string, null)
    # if no value is provided null will be used

    description              = string
  }))

  validation {
    condition = alltrue([ # "alltrue" returns true only if ALL values in the list are true
      for rule in var.rules : 
      # iterates through each rule in the var.rules map , rule represents each individual rule object
      (rule.cidr_blocks != null) != (rule.source_security_group_id != null)
      #first expression returns true if cidr_blocks has a value
      #second experssion returns true if source_security_group_id has a value
      # "!="" is xor which returns true only if the two value are different(true and false or false and true)
      # if both are the same it returns false
    ])
    error_message = "Each rule must specify either cidr_blocks or source_security_group_id, but not both."
  }
}


