
data "aws_availability_zones" "available" {}

# elb will need minimum of 2 azs to work properly
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr



  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]

  map_public_ip_on_launch = true
  enable_nat_gateway      = true


  # required for elb ingress controller
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

}
