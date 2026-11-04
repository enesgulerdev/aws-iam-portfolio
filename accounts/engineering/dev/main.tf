module "engineering_dev_roles" {
  for_each = local.dev_roles
  source   = "../../../modules/iam_role"

  role_name            = each.value.role_name
  principal_identifier = each.value.principal_identifier
  policy_name          = each.value.policy_name
  external_id          = each.value.external_id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = each.key == "rds_abac_manager" ? "ABACControlByDepartmentTags" : "StandardServicePermissions"
        Effect   = "Allow"
        Action   = each.value.actions
        Resource = "*"
        Condition = each.key == "rds_abac_manager" ? {
          StringEquals = {
            "aws:ResourceTag/Department"  = "Engineering"
            "aws:ResourceTag/Environment" = "development"
          }
        } : null
      }
    ]
  })
}

module "engineering_dev_rds" {
  source = "../../../modules/rds_database"

  identifier        = "eng-dev-database"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  db_name           = "engdevdb"
  username          = "postgresadmin"
  password          = "SuperSecureDevPassword123!"

  tags = {
    Environment = "development"
    Department  = "Engineering"
    ManagedBy   = "Terraform"
  }
}