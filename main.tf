provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "update-me"
  region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Add = "tags"
  }
}

module "managed_ad" {
  source = "./modules/managed-ad"

  name     = "example.com"
  password = "password123"
  edition  = "Standard"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

module "rds" {
  source = "./modules/rds"

  engine         = "mssql"
  engine_version = "xxx"
  domain         = module.managed_ad.id


  # fill in remainder

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  security_group_ingress_rules = [
    {
      from_port   = 1433
      to_port     = 1433
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }


  tags = local.tags
}

module "vpc_endpoints_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-vpc-endpoints"
  description = "Security group for VPC endpoint access"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "VPC CIDR HTTPS"
      cidr_blocks = join(",", module.vpc.private_subnets_cidr_blocks)
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "All egress HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc_endpoints_sg.security_group_id]

  endpoints = {
    rds_data = {
      service             = "rds-data"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    }
  }

  tags = local.tags
}
