locals {
  common_tags = {
    Environment = "production"
    Department  = "HR"
    CostCenter  = "HR-Prod"
    ManagedBy   = "Terraform"
    Compliance  = "High"
  }

  hr_prod_roles = {
    core_service = {
      role_name            = "hr-prod-core-service-role"
      principal_identifier = "lambda.amazonaws.com"
      policy_name          = "hr-prod-core-service-policy"
      external_id = null
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  }
}