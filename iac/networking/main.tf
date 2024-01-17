variable "region" {
  type = string
}


variable "subnets" {
  type = map(string)
  nullable = false  
}


variable "tag_name" {
  type = string
  default = "k8ssunnyday"
}


provider "aws" {
    region = var.region
}


# Create vpc
resource "aws_vpc" "k8vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.tag_name}"
  }
}


# Create public subnet
resource "aws_subnet" "pubsubnet1a" {
  cidr_block = var.subnets["sa-east-1a"] # "10.0.16.0/20"
  vpc_id = aws_vpc.k8vpc.id
  availability_zone = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag_name}"
  }
}


# Create private subnet
resource "aws_subnet" "privsubnet1b" {
  cidr_block = var.subnets["sa-east-1b"] # "10.0.32.0/20"
  vpc_id = aws_vpc.k8vpc.id
  availability_zone = "sa-east-1b"

  tags = {
    Name = "${var.tag_name}"
  }
}


# Internet gateway for public subnet 
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.k8vpc.id}"

  tags = {
    Name = "${var.tag_name}"
  }
}


# Create routing from internet
resource "aws_route_table" "igroute" {
  vpc_id = aws_vpc.k8vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}


# Add internet ingress routing to public subnet
resource "aws_route_table_association" "igwrouteassoc" {
  subnet_id = aws_subnet.pubsubnet1a.id
  route_table_id = aws_route_table.igroute.id
}



output "vpc_id" {
  value = aws_vpc.k8vpc.id
}


output "subnet_ids" {
  value = [ aws_subnet.pubsubnet1a.id, aws_subnet.privsubnet1b.id ]
}
