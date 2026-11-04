module "engineering_developer_role" {
  source = "../../../modules/iam_role"

  role_name            = "eng-team-developer-role"
  
  principal_type       = "AWS"
  principal_identifier = "arn:aws:iam::123456789012:root"

  policy_name = "eng-team-developer-debug-policy"
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowDebuggingAndLogs"
        Effect   = "Allow"
        Action   = [
          "cloudwatch:Describe*",
          "logs:GetLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}