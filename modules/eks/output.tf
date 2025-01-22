
output "cluster_endpoint" {
  description = "EKS cluster endpoint url"
  value       = module.eks.cluster_endpoint
}



output "cluster_certificate_authority_data" {
  description = "EKS cluster ca data"
  value       = module.eks.cluster_certificate_authority_data
}



output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

