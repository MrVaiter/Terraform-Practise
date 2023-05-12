resource "kubernetes_service" "gogs_gogs_http" {
  depends_on = [
    kubernetes_namespace.gogs
  ]
  metadata {
    name = "gogs-gogs-http"
    namespace = var.namespace
    labels = {
      app = "gogs-gogs"

      chart = "gogs-0.1.3"

      heritage = "Helm"

      release = "gogs"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "gogs-gogs"
    }

    type = "ClusterIP"
  }
}

