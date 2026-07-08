variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "container_image" {
  description = "Docker image to run (e.g. nginx:latest)"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = string
}

variable "task_memory" {
  description = "Fargate task memory (MB)"
  type        = string
}

variable "desired_count" {
  description = "Number of task instances to run"
  type        = number
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}