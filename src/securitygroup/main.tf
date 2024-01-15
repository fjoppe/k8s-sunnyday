variable "region" {
  type = string
  nullable = false
}


provider "aws" {
  region = var.region
}

