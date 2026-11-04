output "hr_dev_role_arns" {
  value = {
    for key, mod in module.hr_dev_roles : key => mod.role_arn
  }
  description = "Map of all HR dev IAM role ARNs"
}