output "engineering_dev_role_arns" {
  value = {
    for key, mod in module.engineering_dev_roles : key => mod.role_arn
  }
  description = "Map of all engineering dev IAM role ARNs"
}