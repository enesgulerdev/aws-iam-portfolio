module "hr_dev_developer_role" {
  source = "../../../modules/iam_role"

  role_name = "hr-team-developer-role"
  principal_type = "AWS"
  principal_identifier = "arn:aws:iam::111111111111:root"

  policy_name = "hr-dev-developer-policy"
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "AllowHRDevDebugging"
            Effect = "Allow"
            Action = [
                "lambda:GetFunction",
                "lambda:ListFunctions",
                "logs:DescribeLogGroups",
                "logs:GetLogEvents"
            ]
            Resource = "*"
        }
    ]
  })
}