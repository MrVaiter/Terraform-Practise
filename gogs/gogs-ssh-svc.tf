resource "kubernetes_service" "gogs_gogs_ssh" {
  depends_on = [
    kubernetes_namespace.gogs
  ]
  metadata {
    name = "gogs-gogs-ssh"
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
      name        = "ssh"
      protocol    = "TCP"
      port        = 2022
      target_port = "ssh"
    }

    selector = {
      app = "gogs-gogs"
    }

    type = "ClusterIP"
  }
}

