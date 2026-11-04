variable "role_name" {
  type = string
  description = "Name of the IAM Role"
}

variable "principal_type" {
  type = string
  description = "Principal type: Service or AWS"
  default = "Service"
}

variable "principal_identifier" {
  type = string
  description = "The service principal or AWS ARN that can assume this role"
}

variable "external_id" {
  type = string
  description = "Optional External ID required for assuming this role securely"
  default = null
}

variable "policy_name" {
  type = string
  description = "Name of the IAM permission policy"
}

variable "policy_json" {
  type = string
  description = "The JSON policy document defining what this role can do"
}