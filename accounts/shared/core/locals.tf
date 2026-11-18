locals {
  common_tags = {
    Environment = "shared"
    Department  = "Core-Services"
    CostCenter  = "Shared-Infrastructure"
    ManagedBy   = "Terraform"
  }

  shared_roles = {
    cicd_runner = {
      role_name            = "shared-cicd-runner-role"
      principal_identifier = "ec2.amazonaws.com"
      policy_name          = "shared-cicd-runner-policy"
      external_id          = null
      statements = [
        {
          Sid    = "AllowStrictArtifactAndRegistryAccess"
          Effect = "Allow"
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "ecr:GetAuthorizationToken"
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
          Sid    = "DenyEverythingOutsideAuthorizedScope"
          Effect = "Deny"
          NotAction = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        }
      ]
    },
    central_logging = {
      role_name            = "shared-central-logging-role"
      principal_identifier = "cloudtrail.amazonaws.com"
      policy_name          = "shared-central-logging-policy"
      external_id          = null
      statements = [
        {
          Sid    = "AllowCloudTrailLogDelivery"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups"
          ]
          Resource = "*"
          Condition = {
            StringLike = {
              "aws:SourceArn" = "arn:aws:cloudtrail:eu-central-1:*:trail/*"
            }
          }
        },
        {
          Sid    = "DenyLogDeletionOrTampering"
          Effect = "Deny"
          Action = [
            "logs:DeleteLogGroup",
            "logs:DeleteLogStream"
          ]
          Resource = "*"
        }
      ]
    }
  }
}