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
  source = "../vpc"
}


## Managed AD

resource "aws_directory_service_directory" "managed-ad" {
  name     = var.domain-fqdn
  password = var.domain-password
  edition  = var.managed-ad-edition[0]
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = module.vpc.VPC-ID
    subnet_ids = module.vpc.private-subnets-id
  }
}