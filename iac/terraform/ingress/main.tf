variable "region" { 
  type = string
  nullable = false
}

resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "aws eks --region ${var.region} update-kubeconfig --name 'k8s-sunnyday'"
    }
}


provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }    
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true
}