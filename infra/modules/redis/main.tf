# Redis Module — ElastiCache cluster

variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_type" { type = string }
variable "allowed_security_group_ids" { type = list(string) }
variable "num_cache_nodes" { type = number, default = 1 }
variable "engine_version" { type = string, default = "7.0" }

resource "aws_security_group" "redis" {
  name        = "${var.environment}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis from app tier"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  tags = { Name = "${var.environment}-redis-sg" }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.environment}-nexus-redis"
  description                   = "Nexus ${var.environment} Redis cluster"
  node_type                     = var.node_type
  num_cache_clusters            = var.num_cache_nodes
  port                          = 6379
  parameter_group_name          = "default.redis7"
  engine_version                = var.engine_version
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [aws_security_group.redis.id]
  automatic_failover_enabled    = var.num_cache_nodes > 1
  multi_az_enabled              = var.num_cache_nodes > 1
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  notification_topic_arn        = null
  maintenance_window            = "sun:05:00-sun:06:00"
  snapshot_retention_limit      = 7
  snapshot_window               = "03:00-04:00"

  tags = { Name = "${var.environment}-nexus-redis" }
}

# ── Outputs ──
output "endpoint" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "security_group_id" {
  value = aws_security_group.redis.id
}

output "port" {
  value = 6379
}
