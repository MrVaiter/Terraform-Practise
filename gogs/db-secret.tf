resource "kubernetes_secret" "gogs_db" {
  depends_on = [
    kubernetes_namespace.gogs
  ]
  metadata {
    name = "gogs-db"
    namespace = var.namespace
    labels = {
      app = "postgres"

      chart = "gogs-0.1.3"

      heritage = "Helm"

      release = "gogs"
    }
  }

  data = {
    dbPassword = "UncM9WXUut"
  }

  type = "Opaque"
}

