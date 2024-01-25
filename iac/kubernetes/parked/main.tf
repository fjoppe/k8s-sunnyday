variable "cluster_id" {
    type = string
    nullable = false 
    default = "k8s-sunnyday"
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_id
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_namespace" "k8ssunnyday" {
  metadata {
    name = "k8s-sunnynamespace"
  }
}



resource "kubernetes_deployment" "k8ssunnyday_api_deployment" {
  metadata {
    name      = "rest-api"
    namespace = kubernetes_namespace.k8ssunnyday.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "k8sApi"
      }
    }
    template {
      metadata {
        labels = {
          app = "k8sApi"
        }
      }
      spec {
        container {
          image = "422505755735.dkr.ecr.sa-east-1.amazonaws.com/k8simage:restapi-latest"
          name  = "rest-api"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "k8ssunnyday_apiservice" {
  metadata {
    name      = "rest-api"
    namespace = kubernetes_namespace.k8ssunnyday.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.k8ssunnyday_api_deployment.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 8080
    }
  }
}
