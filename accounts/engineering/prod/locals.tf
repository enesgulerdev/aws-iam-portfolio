locals {
  common_tags = {
    Environment = "production"
    Department = "Engineering"
    CostCenter = "Eng-Prod"
    ManagedBy = "Terraform"
    Compliance = "High"
  }

  prod_roles = {
    ecs_execution = {
      role_name = "eng-prod-ecs-task-execution-role"
      principal_identifier = "ecs-tasks.amazonaws.com"
      policy_name = "eng-prod-ecs-execution-policy"
      external_id = null
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  }
}