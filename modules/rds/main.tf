resource "aws_db_instance" "this" {
  engine         = var.engine
  engine_version = var.engine_version
  license_model  = "license-included"
  port           = 1433
  domain         = var.domain

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = false

  timezone           = var.timezone
  character_set_name = var.character_set_name

  backup_window            = var.backup_window
  backup_retention_period  = var.backup_retention_period
  maintenance_window       = var.maintenance_window
  delete_automated_backups = true
  skip_final_snapshot      = true
  deletion_protection      = false

  db_subnet_group_name = aws_db_subnet_group.this.name

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp2"
  storage_encrypted     = true

  username = var.username
  password = var.password

  multi_az               = false
  vpc_security_group_ids = [aws_security_group.this.id]
}

resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Ingress traffic from Private subnets"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
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
