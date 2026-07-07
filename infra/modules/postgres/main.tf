# PostgreSQL Module — RDS instance with read replicas

variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_class" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "allowed_security_group_ids" { type = list(string) }
variable "allocated_storage" { type = number, default = 100 }
variable "backup_retention_days" { type = number, default = 7 }

data "aws_security_group" "app" {
  count = length(var.allowed_security_group_ids) > 0 ? 0 : 0
}

resource "aws_security_group" "db" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  tags = { Name = "${var.environment}-rds-sg" }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.environment}-postgres-pg"
  family = "postgres16"

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.environment}-aurora-pg"
  family      = "aurora-postgresql16"
  description = "Nexus ${var.environment} Aurora PG parameter group"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = { Name = "${var.environment}-rds-subnet-group" }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.environment}-nexus-db"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "16.1"
  database_name           = "nexus"
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  backup_retention_period = var.backup_retention_days
  preferred_backup_window = "03:00-04:00"
  storage_encrypted       = true
  skip_final_snapshot     = var.environment != "production"
  deletion_protection     = var.environment == "production"

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 4
  }

  tags = { Name = "${var.environment}-nexus-db" }
}

resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  db_parameter_group_name = aws_db_parameter_group.this.name

  tags = { Name = "${var.environment}-nexus-db-writer" }
}

resource "aws_rds_cluster_instance" "readers" {
  count              = var.environment == "production" ? 2 : 1
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  db_parameter_group_name = aws_db_parameter_group.this.name

  tags = { Name = "${var.environment}-nexus-db-reader-${count.index + 1}" }
}

# ── Outputs ──
output "endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "security_group_id" {
  value = aws_security_group.db.id
}
