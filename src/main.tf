variable "region" {
  type = string
  default = "sa-east-1"
}


provider "aws" {
    region = var.region
}


module "vpc" {
  source = "./vpc"
  region = var.region
}


# module "securitygroup" {
# source = "./securitygroup"
# region = var.region
# }


module "eks" {
  source = "./eks"
  region = var.region
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}

