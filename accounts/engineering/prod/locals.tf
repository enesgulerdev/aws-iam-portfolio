locals {
  common_tags = {
    Environment = "production"
    Department  = "Engineering"
    CostCenter  = "Eng-Prod"
    ManagedBy   = "Terraform"
    Compliance  = "High"
  }

  identity_roles = {
    ops_readonly = {
      role_name                = "eng-prod-operations-role"
      principal_type           = "AWS"
      principal_identifier     = "arn:aws:iam::999999999999:root"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "eng-prod-ops-readonly-policy"
      statements = [
        {
          Sid    = "AllowReadonlyInspectionInRegion"
          Effect = "Allow"
          Action = [
            "ecs:DescribeClusters",
            "ecs:DescribeServices",
            "cloudwatch:DescribeAlarms",
            "logs:DescribeLogGroups"
          ]
          Resource = "*"
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        }
      ]
    }
  }

  workload_roles = {
    ecs_execution = {
      role_name                = "eng-prod-ecs-task-execution-role"
      principal_type           = "Service"
      principal_identifier     = "ecs-tasks.amazonaws.com"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "eng-prod-ecs-execution-policy"
      statements = [
        {
          Sid       = "AllowEcrAuthToken"
          Effect    = "Allow"
          Action    = ["ecr:GetAuthorizationToken"]
          Resource  = "*"
          Condition = null
        },
        {
          Sid    = "AllowEcsExecutionLogsAndImagesInRegion"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ]
          Resource = "*"
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        }
      ]
    }
  }
}