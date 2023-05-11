resource "kubernetes_namespace" "dev" {
  metadata {
    name = "ns-by-tf-dev"
  }
}

resource "kubernetes_deployment" "dev" {
  metadata {
    name = "terraform-dev"
    labels = {
      test = "app-dev"
    }
    namespace = "ns-by-tf-dev"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "app-dev"
      }
    }

    template {
      metadata {
        labels = {
          test = "app-dev"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
