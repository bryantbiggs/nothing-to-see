variable "name" {
  description = "FQDN of Managed AD domain"
  type        = string
}

variable "password" {
  description = "Password for Managed AD domain"
  type        = string
}

variable "edition" {
  description = "Edition of Managed AD service"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Managed AD service"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Managed AD service"
  type        = list(string)
}
