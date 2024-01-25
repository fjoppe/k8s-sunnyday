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
resource "aws_subnet" "pubsubnets" {
  for_each = var.subnets
  cidr_block =  each.value # "10.0.16.0/20"
  vpc_id = aws_vpc.k8vpc.id
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${each.key}-subnet"
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
  for_each = var.subnets
  subnet_id = aws_subnet.pubsubnets[each.key].id
  route_table_id = aws_route_table.igroute.id
}


output "vpc_id" {
  value = aws_vpc.k8vpc.id
}


output "subnet_ids" {
  value = [ for subnet in aws_subnet.pubsubnets: subnet.id ]
}
