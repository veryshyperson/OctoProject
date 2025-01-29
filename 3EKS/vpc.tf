# networking/main.tf
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
  azs_new = [for az in local.azs : az if az != "us-east-1e"]
  az_count = length(local.azs_new)

  public_subnets = [
    for i in range(local.az_count) :
      cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_subnets = [
    for i in range(local.az_count) :
      cidrsubnet(var.vpc_cidr, 8, i + local.az_count)
  ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.stamp
  cidr = var.vpc_cidr

  azs             = local.azs_new
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Terraform   = "true"
    "kubernetes.io/cluster/${var.stamp}" = "owned"

  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"           = "1"
  }

}
