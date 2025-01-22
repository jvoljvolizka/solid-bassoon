
# allow node group to create alb 
# not the best way on production
resource "aws_iam_policy" "ALBIngressPolicy" {
  name   = "ALBIngressPolicy"
  policy = file("${path.module}/aws-alb-ingress-iam-policy.json")
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.33"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  # required because we are only using public ips
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
      max_size     = 4
      desired_size = 2

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy      = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonGrafanaCloudWatchAccess = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
        ALBIngressPolicy              = aws_iam_policy.ALBIngressPolicy.arn

      }
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets

}
