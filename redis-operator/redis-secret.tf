resource "kubernetes_secret" "redis-secret" {

  depends_on = [
    kubernetes_namespace.redis
  ]

  metadata {
    name      = "redis-name"
    namespace = var.namespace
  }

  data = {
    username = "admin"
    password = "admin"
  }

}