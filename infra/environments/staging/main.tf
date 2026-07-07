# Nexus — Staging Environment
# Terraform configuration for staging infrastructure

terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote state backend (bootstrap before first apply)
  # See infra/README.md for bootstrap instructions
  backend "s3" {
    bucket         = "nexus-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nexus-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

# Generate a random password for the database if not provided
resource "random_password" "db_password" {
  count  = var.db_password == "" ? 1 : 0
  length = 24
  special = false
}

locals {
  db_password = var.db_password != "" ? var.db_password : random_password.db_password[0].result
}

# ────────── Network ──────────
module "network" {
  source = "../../modules/network"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

# ────────── PostgreSQL ──────────
module "postgres" {
  source = "../../modules/postgres"

  environment     = var.environment
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_db_subnet_ids
  instance_class  = var.db_instance_class
  db_username     = var.db_username
  db_password     = local.db_password
  allowed_security_group_ids = [module.network.app_security_group_id]
}

# ────────── Redis ──────────
module "redis" {
  source = "../../modules/redis"

  environment     = var.environment
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_app_subnet_ids
  node_type       = var.redis_node_type
  allowed_security_group_ids = [module.network.app_security_group_id]
}

# ────────── Outputs ──────────
output "vpc_id" {
  value = module.network.vpc_id
}

output "database_endpoint" {
  value = module.postgres.endpoint
  sensitive = true
}

output "redis_endpoint" {
  value = module.redis.endpoint
  sensitive = true
}

output "database_password" {
  value     = local.db_password
  sensitive = true
  description = "Store this securely — it will not be shown again"
}
