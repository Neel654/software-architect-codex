# Nexus Infrastructure (Terraform)

## Overview

This directory contains Terraform configurations to provision AWS infrastructure for the Nexus platform.

## Prerequisites

- Terraform >= 1.6
- AWS CLI configured with appropriate credentials
- S3 bucket for remote state (bootstrap below)

## Directory Structure

```
infra/
├── modules/
│   ├── network/        # VPC, subnets, NAT gateway, internet gateway
│   ├── postgres/       # RDS PostgreSQL instance + read replicas
│   └── redis/          # ElastiCache Redis cluster
├── environments/
│   └── staging/
│       ├── main.tf     # Root module composing all resources
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
└── README.md
```

## Remote State Bootstrap

Terraform state is stored in S3 with DynamoDB locking. Bootstrap once:

```bash
# Replace BUCKET_NAME with a globally unique name
aws s3api create-bucket \
  --bucket nexus-terraform-state \
  --region us-east-1

aws dynamodb create-table \
  --table-name nexus-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

## Usage

```bash
cd infra/environments/staging

# Copy and edit variables
cp terraform.tfvars.example terraform.tfvars

# Initialize (downloads providers, configures backend)
terraform init

# Preview changes
terraform plan

# Apply
terraform apply

# Destroy (when no longer needed)
terraform destroy
```

## Variables

See `environments/staging/variables.tf` for all required and optional variables.

Key variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `environment` | Environment name | `staging` |
| `aws_region` | AWS region | `us-east-1` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `db_instance_class` | RDS instance type | `db.t3.medium` |
| `redis_node_type` | ElastiCache node type | `cache.t3.micro` |

## Security

- All secrets (DB password, Redis auth token) should be stored in AWS Secrets Manager, not in Terraform state
- Database subnets are private — no direct internet access
- Security groups restrict traffic to necessary ports only
