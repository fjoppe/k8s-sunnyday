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


variable "private_subnetcidr" {
  type = list(string)
  nullable = false 
}

variable "public_subnetcidr" {
  type = list(string)
  nullable = false 
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


resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [flatten(var.private_subnetcidr, var.public_subnetcidr)]
}


resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port   = 1025
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = flatten([var.private_subnetcidr])
}

