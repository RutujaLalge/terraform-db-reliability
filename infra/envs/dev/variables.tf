variable "project_name" {
  type    = string
  default = "hotelbookings"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "container_image" {
  type    = string
  default = "nginx:latest"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
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

variable "db_backup_retention_period" {
  type    = number
  default = 1
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "ecs_task_cpu" {
  type    = string
  default = "256"
}

variable "ecs_task_memory" {
  type    = string
  default = "512"
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}