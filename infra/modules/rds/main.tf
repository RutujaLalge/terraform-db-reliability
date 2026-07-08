# ---------------------------------------------------------
# DB Subnet Group (tells RDS which private subnets it can use)
# ---------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# ---------------------------------------------------------
# RDS PostgreSQL Instance
# ---------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = "postgres"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_security_group_id]

  # RDS must be private — never publicly reachable
  publicly_accessible = false

  backup_retention_period = var.backup_retention_period
  backup_window            = "03:00-04:00"
  maintenance_window        = "mon:04:30-mon:05:30"

  deletion_protection = var.deletion_protection
  skip_final_snapshot  = var.deletion_protection ? false : true
  final_snapshot_identifier = var.deletion_protection ? "${var.project_name}-${var.environment}-final-snapshot" : null

  multi_az = var.multi_az

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
  }
}