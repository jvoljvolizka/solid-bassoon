terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
  required_version = ">= 1.3"
}
