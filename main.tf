


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "worktest-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  #  enable_vpn_gateway = true


}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.33"

  cluster_name    = "worktest-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    # we need this to use ebs with ec2 
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  # we need to keep grafana stack on ec2 nodes because fargate can't use ebs
  eks_managed_node_groups = {


    node_group = {
      labels = {
        role = "monitoring"
      }
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy      = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonGrafanaCloudWatchAccess = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
      }
    }
  }


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  values           = [file("${path.module}/prometheus-values.yaml")]

}


resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  values           = [file("${path.module}/grafana-values.yaml")]

}
