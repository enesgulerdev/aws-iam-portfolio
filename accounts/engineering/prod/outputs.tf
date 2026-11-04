output "engineering_prod_role_arns" {
  value = {
    for key, mod in module.engineering_prod_roles : key => mod.role_arn
  }
  description = "Map of all engineering prod IAM role ARNs"
}