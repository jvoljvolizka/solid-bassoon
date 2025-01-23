

module "vpc" {
  source = "./modules/vpc"
  name   = var.vpc_name
  cidr   = var.cidr
}


module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  cluster_name    = var.cluster_name
}


module "helm" {
  source       = "./modules/helm"
  cluster_name = module.eks.cluster_name
  region       = var.region

}


