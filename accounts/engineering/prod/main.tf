module "engineering_prod_roles" {
  for_each = local.prod_roles
  source   = "../../../modules/iam_role"

  role_name            = each.value.role_name
  principal_identifier = each.value.principal_identifier
  policy_name          = each.value.policy_name
  external_id = each.value.external_id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "EngProdDynamicPermissions"
        Effect   = "Allow"
        Action   = each.value.actions
        Resource = "*"
      }
    ]
  })
}