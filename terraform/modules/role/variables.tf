variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "policy_arns" {
  description = "The ARN of the IAM policy ARNs to attach"
  type        = list(string)
}

