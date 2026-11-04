locals {
  common_tags = {
    Environment = "development"
    Department = "Engineering"
    CostCenter = "Eng-Dev"
    ManagedBy = "Terraform"
  }

  dev_roles = {
    ecs_execution = {
      role_name = "eng-ecs-task-execution-role"
      principal_identifier = "ecs-tasks.amazonaws.com"
      policy_name = "eng-ecs-execution-policy"
      external_id = null
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer"
      ]
    },

    rds_abac_manager = {
      role_name = "eng-dev-rds-abac-manager-role"
      principal_identifier = "ec2.amazonaws.com"
      policy_name = "eng-dev-rds-abac-manager-policy"
      external_id = null
      actions = [
        "rds:DescribeDBInstances",
        "rds:ListTagsForResource",
        "rds:Connect"
      ]
    }
  }
}