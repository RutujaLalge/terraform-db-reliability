variable "project_name" {
  description = "Name used as a prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
}

variable "container_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "Port the database listens on"
  type        = number
  default     = 5432
}