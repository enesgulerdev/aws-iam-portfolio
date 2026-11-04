output "db_instance_arn" {
  value       = aws_db_instance.this.arn
  description = "ARN of the RDS instance"
}

output "db_instance_id" {
  value       = aws_db_instance.this.id
  description = "ID of the RDS instance"
}