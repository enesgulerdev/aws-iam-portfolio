module "engineering_prod_ops_role" {
  source = "../../../modules/iam_role"

  role_name = "eng-prod-operations-role"
  principal_type = "AWS"
  principal_identifier = "arn:aws:iam::999999999999:root"

  policy_name = "eng-prod-ops-readonly-policy"
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "AllowReadonlyInspection"
            Effect = "Allow"
            Action = [
                "ecs:DescribeClusters",
                "ecs:DescribeServices",
                "cloudwatch:DescribeAlarms",
                "logs:DescribeLogGroups"
            ]
            Resource = "*"
        }
    ]
  })
}