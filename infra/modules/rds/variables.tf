variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from the network module"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group ID from the network module"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance size"
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  type    = string
  default = "hotel_bookings_db"
}

variable "db_username" {
  type      = string
  default   = "hotel_admin"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
}

variable "multi_az" {
  description = "Whether to deploy a standby replica in another AZ"
  type        = bool
  default     = false
}