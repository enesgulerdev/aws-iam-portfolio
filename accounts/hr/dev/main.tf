module "hr_dev_roles" {
  for_each = local.hr_dev_roles
  source   = "../../../modules/iam_role"

  role_name            = each.value.role_name
  principal_identifier = each.value.principal_identifier
  policy_name          = each.value.policy_name
  external_id = each.value.external_id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "HRDevLambdaDynamicPermissions"
        Effect   = "Allow"
        Action   = each.value.actions
        Resource = "*"
      }
    ]
  })
}