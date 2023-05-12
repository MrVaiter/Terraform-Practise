resource "kubernetes_config_map" "gogs_gogs" {
  depends_on = [
    kubernetes_namespace.gogs
  ]
  metadata {
    name = "gogs-gogs"
    namespace = var.namespace
    labels = {
      app = "gogs-gogs"

      chart = "gogs-0.1.3"

      heritage = "Helm"

      release = "gogs"
    }
  }

  data = {
    "app-pls.ini" = local.gogs_config
  }
}

