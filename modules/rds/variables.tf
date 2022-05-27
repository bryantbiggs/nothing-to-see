variable "vpc_id" {
  description = "VPC identifier"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS instance"
  type        = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "domain" {
  description = "Database domain"
  type        = string
}

variable "timezone" {
  description = "Database timezone"
  type        = string
}

variable "character_set_name" {
  description = "Database character set"
  type        = string
}

variable "backup_window" {
  description = "Database backup window"
  type        = string
}

variable "backup_retention_period" {
  description = "Database backup retention period"
  type        = number
}

variable "maintenance_window" {
  description = "Database maintenance window"
  type        = string
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Database allocated storage"
  type        = number
}

variable "max_allocated_storage" {
  description = "Database max allocated storage"
  type        = number
}

variable "username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "subnet_group_name" {
  description = "Database subnet group name"
  type        = string
}

variable "security_group_name" {
  description = "Database security group name"
  type        = string
}

variable "security_group_ingress_rules" {
  description = "Database security group ingress rules"
  type        = list(any)
}
