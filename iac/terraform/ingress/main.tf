data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json"
}


variable "region" { 
  type = string
  nullable = false
}

variable "cluster_id" {
    type = string
    default = "k8s-sunnyday"
}

variable "k8snamespace" {
    type = string
    nullable = false
}


data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}


provider "aws" {
  region = var.region
}


resource "aws_iam_policy" "albingresscontrollerpolicy" {
    name = "ALBIngressControllerIAMPolicy"
    policy = data.http.iam_policy.response_body
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

resource "aws_iam_role" "k8singressrole" {
    name = "k8s-alb-ingress-role"
    assume_role_policy = data.aws_iam_policy_document.k8assumerolepolicy.json
}


resource "aws_iam_role_policy_attachment" "albingresscontrollerpolicyattach" {
  policy_arn = aws_iam_policy.albingresscontrollerpolicy.arn
  role = aws_iam_role.k8singressrole.name
}


module "kubernetes-iamserviceaccount" {
  source  = "bigdatabr/kubernetes-iamserviceaccount/aws"
  version = "1.1.1"

  cluster_name = data.aws_eks_cluster.cluster.name
  namespace = var.k8snamespace
  role_name = aws_iam_role.k8singressrole.name
  service_account_name = "alb-ingress-controller"
}

