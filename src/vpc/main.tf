variable "region" {
  type = string
}


provider "aws" {
    region = var.region
}


resource "aws_vpc" "k8vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "k8subnet" {
  cidr_block = "10.4.0.0/16"
  vpc_id = aws_vpc.k8vpc.id
}


output "vpc_id" {
  value = aws_vpc.k8vpc.id
}

output "subnet_id" {
  value = aws_subnet.k8subnet.id
}