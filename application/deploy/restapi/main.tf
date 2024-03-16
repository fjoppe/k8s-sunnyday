provider "kubernetes" {
    config_path = "~/.kube/config"
}


resource "kubernetes_deployment" "restapi" {
  metadata {
    name = "restapi-ns"
    labels = {
      app = "restapi"
      group = "frontend"
    }
  }



  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "restapi"
      }      
    }

    template {
      metadata {
        labels = {
          app = "restapi"
          group = "frontend"          
        }
      }

      spec {
        container {
          name = "restapi"
          image = "422505755735.dkr.ecr.sa-east-1.amazonaws.com/k8simage:restapi-latest"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          env {
            name = "DBENDPOINT"
            value = "http://database:3000"
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "restapi" {
  metadata {
    name = "restapi"
    labels = {
      app = "restapi"
      group = "frontend"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.restapi.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}



data "kubernetes_service" "ingress" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}



resource "kubernetes_ingress_v1" "restapi-ingress-rule" {
  wait_for_load_balancer = true
  metadata {
    name = "restapi"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.hostname
      http {
        path {
          path = "/test"
          path_type = "Prefix"
          backend {
            service {
              name = "restapi"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}


