output "shared_role_arns" {
  value = {
    for key, mod in module.shared_roles : key => mod.role_arn
  }
  description = "Map of all shared IAM role ARNs created via for_each"
}