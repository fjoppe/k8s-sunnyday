provider "kubernetes" {
    config_path = "~/.kube/config"
}

variable "region" {
  type = string
  default = "sa-east-1"
}

provider "aws" {
    region = var.region
}


module "restapi" {
  source = "./restapi"
}

