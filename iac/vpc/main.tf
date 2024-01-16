variable "region" {
  type = string
}


provider "aws" {
    region = var.region
}


resource "aws_vpc" "k8vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "k8subnet1a" {
  cidr_block = "10.0.16.0/20"
  vpc_id = aws_vpc.k8vpc.id
  availability_zone = "sa-east-1a"
}

resource "aws_subnet" "k8subnet1b" {
  cidr_block = "10.0.32.0/20"
  vpc_id = aws_vpc.k8vpc.id
  availability_zone = "sa-east-1b"
}


output "vpc_id" {
  value = aws_vpc.k8vpc.id
}

output "subnet_ids" {
  value = [ aws_subnet.k8subnet1a.id, aws_subnet.k8subnet1b.id ]
}
