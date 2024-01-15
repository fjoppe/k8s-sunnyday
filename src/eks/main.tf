variable "region" {
  type = string
  nullable = false
}

variable "vpc_id" {
  type = string
  nullable = false
}

variable "subnet_id" {
  type = string
  nullable = false
}

provider "aws" {
  region = var.region
}


data "aws_iam_policy_document" "k8assumerolepolicy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "k8eksrole" {
    name = "k8s-cluster-role"
    assume_role_policy = data.aws_iam_policy_document.k8assumerolepolicy.json
}


resource "aws_iam_role_policy_attachment" "attach-EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.k8eksrole.name
}

resource "aws_eks_cluster" "sunnyday" {
    name = "k8s-sunnyday"
    role_arn = aws_iam_role.k8eksrole.arn

    vpc_config {
      vpc_id = var.vpc_id
      subnet_ids = [ var.subnet_id ]
    }

    depends_on = [ aws_iam_role_policy_attachment.attach-EKSClusterPolicy ]
}

output "endpoint" {
    value = aws_eks_cluster.sunnyday.endpoint  
}

