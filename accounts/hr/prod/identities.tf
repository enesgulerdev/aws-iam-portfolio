module "hr_prod_auditor_role" {
  source = "../../../modules/iam_role"

  role_name            = "hr-prod-auditor-role"
  principal_type       = "AWS"
  principal_identifier = "arn:aws:iam::111111111111:root"

  policy_name = "hr-prod-auditor-policy"
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowHRAuditReadonly"
        Effect   = "Allow"
        Action   = [
          "cloudwatch:DescribeAlarms",
          "logs:DescribeLogGroups",
          "logs:GetLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}