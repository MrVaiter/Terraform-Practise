resource "kubernetes_service" "redis_operator" {
  depends_on = [
    kubernetes_namespace.redis
  ]
  metadata {
    name      = "redis-operator"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/instance" = "redis-operator"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "redis-operator"

      "app.kubernetes.io/part-of" = "redis-operator"

      "app.kubernetes.io/version" = "1.2.4"

      "helm.sh/chart" = "redis-operator-3.2.7"
    }
  }

  spec {
    port {
      name     = "metrics"
      protocol = "TCP"
      port     = 9710
    }

    selector = {
      "app.kubernetes.io/instance" = "redis-operator"

      "app.kubernetes.io/name" = "redis-operator"
    }

    type = "ClusterIP"
  }
}

