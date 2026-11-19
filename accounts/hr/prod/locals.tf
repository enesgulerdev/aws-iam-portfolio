locals {
  common_tags = {
    Environment = "production"
    Department  = "HR"
    CostCenter  = "HR-Prod"
    ManagedBy   = "Terraform"
    Compliance  = "High"
  }

  identity_roles = {
    auditor = {
      role_name                = "hr-prod-auditor-role"
      principal_type           = "AWS"
      principal_identifier     = "arn:aws:iam::111111111111:root"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "hr-prod-auditor-policy"
      statements = [
        {
          Sid    = "AllowHRAuditReadonlyInProd"
          Effect = "Allow"
          Action = [
            "cloudwatch:DescribeAlarms",
            "logs:DescribeLogGroups",
            "logs:GetLogEvents"
          ]
          NotAction = null
          Resource  = "*"
          Condition = {
            StringEquals = {
              "aws:RequestedRegion"         = "eu-central-1"
              "aws:PrincipalTag/Department" = "HR"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        },
        {
          Sid    = "AllowHRProdAuditScopedViaNotAction"
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
              "aws:RequestedRegion"         = "eu-central-1"
              "aws:PrincipalTag/Department" = "HR"
            }
            Bool = {
              "aws:SecureTransport" = "true"
            }
          }
        },
        {
          Sid    = "DenyHRProdAuditDestructiveActions"
          Effect = "Deny"
          Action = [
            "logs:DeleteLogGroup",
            "cloudwatch:DeleteAlarms",
            "lambda:DeleteFunction"
          ]
          NotAction = null
          Resource  = "*"
          Condition = null
        }
      ]
    }
  }

  workload_roles = {
    core_service = {
      role_name                = "hr-prod-core-service-role"
      principal_type           = "Service"
      principal_identifier     = "lambda.amazonaws.com"
      permissions_boundary_arn = null
      external_id              = null
      policy_name              = "hr-prod-core-service-policy"
      statements = [
        {
          Sid    = "HRProdSecureLogsDynamic"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
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
          Sid    = "AllowHRProdCoreServiceScopedViaNotAction"
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
          Sid    = "DenyHRProdCoreServiceDestructiveActions"
          Effect = "Deny"
          Action = [
            "logs:DeleteLogGroup",
            "logs:DeleteLogStream",
            "lambda:DeleteFunction"
          ]
          NotAction = null
          Resource  = "*"
          Condition = null
        }
      ]
    }
  }
}