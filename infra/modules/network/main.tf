# Network Module — VPC, subnets, gateways, security groups

variable "environment" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_app_subnet_cidrs" { type = list(string) }
variable "private_db_subnet_cidrs" { type = list(string) }

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${var.environment}-vpc" }
}

# ── Internet Gateway ──
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.environment}-igw" }
}

# ── NAT Gateway ──
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.environment}-nat-eip" }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = { Name = "${var.environment}-nat" }
}

# ── Public Subnets ──
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "${var.environment}-public-${count.index + 1}" }
}

# ── Private App Subnets ──
resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.environment}-private-app-${count.index + 1}" }
}

# ── Private DB Subnets ──
resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.environment}-private-db-${count.index + 1}" }
}

# ── Route Tables ──
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.environment}-public-rt" }
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = { Name = "${var.environment}-private-app-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_app.id
}

# ── Security Groups ──
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security group for application tier"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.environment}-app-sg" }
}

resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Security group for database tier"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "PostgreSQL from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = []  # Will be populated by postgres module
  }

  tags = { Name = "${var.environment}-db-sg" }
}

# ── Data Sources ──
data "aws_availability_zones" "available" {
  state = "available"
}

# ── Outputs ──
output "vpc_id" { value = aws_vpc.this.id }

output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_app_subnet_ids" { value = aws_subnet.private_app[*].id }
output "private_db_subnet_ids" { value = aws_subnet.private_db[*].id }

output "app_security_group_id" { value = aws_security_group.app.id }
output "db_security_group_id" { value = aws_security_group.db.id }

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private_db[*].id
  tags       = { Name = "${var.environment}-db-subnet-group" }
}
