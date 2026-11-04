locals {
  common_tags = {
    Environment = "shared"
    Department = "Core-Services"
    CostCenter = "Shared-Infrastructure"
    ManagedBy = "Terraform"
  }

  shared_roles = {
    cicd_runner = {
        role_name = "shared-cicd-runner-role"
        principal_identifier = "ec2.amazonaws.com"
        policy_name = "shared-cicd-runner-policy"
        external_id = null
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "ecr:GetAuthorizationToken"
        ]
    },
    central_logging = {
        role_name = "shared-central-logging-role"
        principal_identifier = "cloudtrail.amazonaws.com"
        policy_name = "shared-central-logging-policy"
        external_id = null
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups"
        ]
    }
  }
}