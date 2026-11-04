output "role_arn" {
  value = aws_iam_role.this.arn
  description = "The ARN of the created IAM Role"
}

output "role_name" {
  value = aws_iam_role.this.name
  description = "The name of the created IAM Role"
}