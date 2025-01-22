
output "vpc_id" {
  description = "AWS vpc id"
  value       = module.vpc.vpc_id
}



output "public_subnets" {
  description = "Public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.vpc.private_subnets
}

