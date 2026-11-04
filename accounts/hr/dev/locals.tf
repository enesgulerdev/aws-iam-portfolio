locals {
  common_tags = {
    Environment = "development"
    Department  = "HR"
    CostCenter  = "HR-Dev"
    ManagedBy   = "Terraform"
  }

  hr_dev_roles = {
    lambda_automation = {
      role_name            = "hr-dev-lambda-automation-role"
      principal_identifier = "lambda.amazonaws.com"
      policy_name          = "hr-dev-lambda-policy"
      external_id = null
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "s3:GetObject",
        "s3:ListBucket"
      ]
    }
  }
}