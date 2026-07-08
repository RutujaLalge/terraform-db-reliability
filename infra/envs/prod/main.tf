terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------
# Network Module
# ---------------------------------------------------------
module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  container_port       = var.container_port
  db_port              = var.db_port
}

# ---------------------------------------------------------
# RDS Module
# ---------------------------------------------------------
module "rds" {
  source = "../../modules/rds"

  project_name            = var.project_name
  environment             = var.environment
  private_subnet_ids      = module.network.private_subnet_ids
  rds_security_group_id   = module.network.rds_security_group_id
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_username             = var.db_username
  db_password             = var.db_password
  db_port                 = var.db_port
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
  multi_az                = var.db_multi_az
}

# ---------------------------------------------------------
# ECS Module
# ---------------------------------------------------------
module "ecs" {
  source = "../../modules/ecs"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id
  ecs_security_group_id = module.network.ecs_security_group_id
  container_image       = var.container_image
  container_port        = var.container_port
  task_cpu              = var.ecs_task_cpu
  task_memory           = var.ecs_task_memory
  desired_count         = var.ecs_desired_count
}