terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../modules/vpc"
}

module "managed-ad" {
  source = "../modules/managed-ad"
}

## Security Groups

resource "aws_security_group" "rdssql-ingress" {
  name        = var.rdssql-ingress-name
  description = "Ingress traffic from Private subnets"
  vpc_id      = module.vpc.VPC-ID

  dynamic "ingress" {
    for_each = var.rdssql-ingress-ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = module.vpc.private-subnets-cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

## VPC Endpoints

resource "aws_vpc_endpoint" "rds-vpc-endpoint" {
  vpc_id              = module.vpc.VPC-ID
  subnet_ids          = module.vpc.private-subnets-id
  service_name        = "com.amazonaws.us-east-1.rds-data"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  security_group_ids  = [aws_security_group.rdssql-ingress.id]
  private_dns_enabled = true

}


## DB Subnet Group

resource "aws_db_subnet_group" "rdssql-db-subnet-group" {
  name       = var.rdssql-db-subnet-group-name
  subnet_ids = module.vpc.private-subnets-id
}


## Amazon RDS for SQL Server

resource "aws_db_instance" "rds-sql-server" {
  engine         = var.rdssql-engine[0]
  engine_version = var.rdssql-engine-version[0]
  license_model  = "license-included"
  port           = 1433
  domain         = module.managed-ad.managed-ad-id
  depends_on = [
    module.managed-ad, module.vpc
  ]

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = false

  timezone           = var.time-zone
  character_set_name = var.sql-collation

  backup_window            = var.backup-windows-retention-maintenance[0]
  backup_retention_period  = var.backup-windows-retention-maintenance[1]
  maintenance_window       = var.backup-windows-retention-maintenance[2]
  delete_automated_backups = true
  skip_final_snapshot      = true
  deletion_protection      = false

  db_subnet_group_name = aws_db_subnet_group.rdssql-db-subnet-group.name

  instance_class = var.rds-db-instance-class

  allocated_storage     = var.storage-allocation[0]
  max_allocated_storage = var.storage-allocation[1]
  storage_type          = "gp2"
  storage_encrypted     = true

  username = var.user-name
  password = var.rdssql-password

  multi_az               = false
  vpc_security_group_ids = [aws_security_group.rdssql-ingress.id]
}
