variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "profile" {
  description = "AWS cli profile"
  type        = string
  default     = "default"
}

variable "vpc_name" {
  description = "AWS VPC name"
  type        = string
  default     = "worktest"
}

variable "cidr" {
  description = "cidr for vpc subnets"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "worktest-cluster"
}

