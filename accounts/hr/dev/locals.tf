locals {
  common_tags = {
    Environment = "development"
    Department  = "HR"
    CostCenter  = "HR-Dev"
    ManagedBy   = "Terraform"
  }

  identity_roles = {
    developer = {
      role_name                = "hr-team-developer-role"
      principal_type           = "AWS"
      principal_identifier     = "arn:aws:iam::111111111111:root"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "hr-dev-developer-policy"
      statements = [
        {
          Sid    = "AllowHRDevDebuggingInRegion"
          Effect = "Allow"
          Action = [
            "lambda:GetFunction",
            "lambda:ListFunctions",
            "logs:DescribeLogGroups",
            "logs:GetLogEvents"
          ]
          NotAction = null
          Resource  = "*"
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        },
        {
          Sid    = "AllowNonSensitiveReadActionsViaNotAction"
          Effect = "Allow"
          Action = null
          NotAction = [
            "iam:*",
            "organizations:*",
            "kms:ScheduleKeyDeletion",
            "kms:DisableKey"
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
        },
        {
          Sid    = "DenyDestructiveLambdaAndLogActions"
          Effect = "Deny"
          Action = [
            "lambda:DeleteFunction",
            "lambda:UpdateFunctionCode",
            "logs:DeleteLogGroup"
          ]
          NotAction = null
          Resource  = "*"
          Condition = null
        }
      ]
    }
  }

  workload_roles = {
    lambda_automation = {
      role_name                = "hr-dev-lambda-automation-role"
      principal_type           = "Service"
      principal_identifier     = "lambda.amazonaws.com"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "hr-dev-lambda-policy"
      statements = [
        {
          Sid    = "AllowHRDevLambdaLogsAndS3Read"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "s3:GetObject",
            "s3:ListBucket"
          ]
          NotAction = null
          Resource  = "*"
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "eu-central-1"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        },
        {
          Sid    = "AllowHRDevLambdaScopedActionsViaNotAction"
          Effect = "Allow"
          Action = null
          NotAction = [
            "iam:*",
            "kms:*",
            "s3:DeleteBucket"
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
        },
        {
          Sid    = "DenyHRDevLambdaDestructiveS3Actions"
          Effect = "Deny"
          Action = [
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:PutObject"
          ]
          NotAction = null
          Resource  = "*"
          Condition = null
        }
      ]
    }
  }
}