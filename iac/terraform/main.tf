variable "region" {
  type = string
  default = "sa-east-1"
}

variable "subnets" {
  type = map(string)
  default = {
    "sa-east-1a" = "10.0.16.0/20"
    "sa-east-1b" = "10.0.32.0/20"
  }  
}

provider "aws" {
    region = var.region
}


module "networking" {
  source = "./networking"
  region = var.region
  subnets = var.subnets
}


module "eks" {
  source = "./eks"
  region = var.region
  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.subnet_ids
}


module "ingress" {
  source = "./ingress"
  region = var.region
  k8snamespace = "kube-system"  
}


output "cluster_id" {
  value = module.eks.cluster_id
}

