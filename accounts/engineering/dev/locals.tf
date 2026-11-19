locals {
  common_tags = {
    Environment = "development"
    Department  = "Engineering"
    CostCenter  = "Eng-Dev"
    ManagedBy   = "Terraform"
  }

  # =========================================================================
  # 1. IDENTITY ROLES
  # =========================================================================
  identity_roles = {
    developer = {
      role_name                = "eng-team-developer-role"
      principal_type           = "AWS"
      principal_identifier     = "arn:aws:iam::123456789012:root"
      permissions_boundary_arn = "arn:aws:iam::123456789012:policy/engineering-team-boundary"
      external_id              = null
      policy_name              = "eng-team-developer-debug-policy"
      statements = [
        {
          Sid    = "AllowDebuggingAndLogsInAuthorizedRegion"
          Effect = "Allow"
          Action = [
            "cloudwatch:Describe*",
            "logs:GetLogEvents"
          ]
          Resource = "*"
          Condition = {
            Bool = {
              "aws:SecureTransport" = "true"
            }
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
          }
        },
        {
          Sid      = "DenyAllActionsWithoutMFA"
          Effect   = "Deny"
          Action   = "*"
          Resource = "*"
          Condition = {
            BoolIfExists = {
              "aws:MultiFactorAuthPresent" = "false"
            }
          }
        },
        {
          Sid    = "DenyDestructiveLogAndIAMActions"
          Effect = "Deny"
          Action = [
            "logs:DeleteLogGroup",
            "logs:DeleteLogStream",
            "iam:*"
          ]
          Resource = "*"
        }
      ]
    }
  }

  # =========================================================================
  # 2. WORKLOAD ROLES
  # =========================================================================
  workload_roles = {
    ecs_execution = {
      role_name                = "eng-ecs-task-execution-role"
      principal_type           = "Service"
      principal_identifier     = "ecs-tasks.amazonaws.com"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "eng-ecs-execution-policy"
      statements = [
        {
          Sid    = "AllowECSTaskExecutionScoped"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer"
          ]
          Resource = "*"
          Condition = {
            Bool = {
              "aws:SecureTransport" = "true"
            }
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
          }
        },
        {
          Sid    = "SandboxECSExecutionToAllowedServices"
          Effect = "Deny"
          NotAction = [
            "logs:*",
            "ecr:*"
          ]
          Resource = "*"
        }
      ]
    },

    rds_abac_manager = {
      role_name                = "eng-dev-rds-abac-manager-role"
      principal_type           = "Service"
      principal_identifier     = "ec2.amazonaws.com"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "eng-dev-rds-abac-manager-policy"
      statements = [
        {
          Sid    = "AllowRDSDescribeAndList"
          Effect = "Allow"
          Action = [
            "rds:DescribeDBInstances",
            "rds:ListTagsForResource"
          ]
          Resource = "*"
        },
        {
          Sid      = "AllowRDSConnectWithABACTags"
          Effect   = "Allow"
          Action   = ["rds-db:connect"]
          Resource = "arn:aws:rds-db:eu-central-1:123456789012:dbuser:*/*"
          Condition = {
            StringEquals = {
              "aws:ResourceTag/Department"  = "Engineering"
              "aws:ResourceTag/Environment" = "development"
            }
          }
        }
      ]
    }
  }
}