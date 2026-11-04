output "hr_prod_role_arns" {
  value = {
    for key, mod in module.hr_prod_roles : key => mod.role_arn
  }
  description = "Map of all HR prod IAM role ARNs"
}