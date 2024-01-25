variable "region" { 
  type = string
  nullable = false
}


variable "vpc_id" {
  type = string
  nullable = false
}


variable "subnet_ids" {
  type = list(string)
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
      subnet_ids = var.subnet_ids 
    }

    depends_on = [ aws_iam_role_policy_attachment.attach-EKSClusterPolicy ]
}



data "aws_iam_policy_document" "k8nodegroupassumerolepolicy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "k8snodegrouprole" {
    name = "k8s-nodegroup-role"
    assume_role_policy = data.aws_iam_policy_document.k8nodegroupassumerolepolicy.json  
}


resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8snodegrouprole.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8snodegrouprole.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8snodegrouprole.name
}

resource "aws_eks_node_group" "sunnydaygroup" {
  cluster_name    = aws_eks_cluster.sunnyday.name
  node_group_name = "sunnydaygroup"
  node_role_arn   = aws_iam_role.k8snodegrouprole.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}


output "endpoint" {
    value = aws_eks_cluster.sunnyday.endpoint  
}


output "cluster_id" {
  value = aws_eks_cluster.sunnyday.cluster_id
}