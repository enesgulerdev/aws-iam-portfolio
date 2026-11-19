module "engineering_prod_identities" {
  for_each = local.identity_roles
  source   = "../../../modules/iam_role"

  role_name                = each.value.role_name
  principal_type           = each.value.principal_type
  principal_identifier     = each.value.principal_identifier
  permissions_boundary_arn = lookup(each.value, "permissions_boundary_arn", null)
  external_id              = lookup(each.value, "external_id", null)

  policy_name = each.value.policy_name
  policy_json = jsonencode({
    Version   = "2012-10-17"
    Statement = each.value.statements
  })

  tags = local.common_tags
}