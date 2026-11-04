variable "identifier" {
  type        = string
  description = "The name/identifier of the RDS instance"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The allocated storage in gigabytes"
}

variable "engine" {
  type        = string
  default     = "postgres"
  description = "The database engine to use"
}

variable "engine_version" {
  type        = string
  default     = "15.4"
  description = "The engine version to use"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance type of the RDS instance"
}

variable "db_name" {
  type        = string
  default     = "appdb"
  description = "The name of the database to create when the DB is created"
}

variable "username" {
  type        = string
  default     = "dbadmin"
  description = "Username for the master DB user"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Password for the master DB user"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the RDS instance for ABAC validation"
}