variable "region" {
  type = string
  nullable = false
}

variable "vpc_id" {
  type = string
  nullable = false
}

variable "tag_name" {
  type = string
  default = "k8ssunnyday"
}


provider "aws" {
  region = var.region
}


resource "aws_security_group" "public_sg" {
  name = "public-sg"
  vpc_id = var.vpc_id

    tags = {
    Name = "${var.tag_name}-sg"
  }
}

resource "aws_security_group_rule" "public_sg_ingress_public_80" {
  security_group_id = aws_security_group.public_sg.id
  type = ingress
  from_port = 80
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}


resource "aws_security_group" "k8sdataplane" {
  name = "k8s-dataplane-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.tag_name}-sg"
  }
}