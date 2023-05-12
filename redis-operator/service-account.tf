resource "kubernetes_service_account" "redis_operator" {
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
}

resource "kubernetes_cluster_role" "redis_operator" {
  metadata {
    name = "redis-operator"

    labels = {
      "app.kubernetes.io/instance" = "redis-operator"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "redis-operator"

      "app.kubernetes.io/part-of" = "redis-operator"

      "app.kubernetes.io/version" = "1.2.4"

      "helm.sh/chart" = "redis-operator-3.2.7"
    }
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["databases.spotahome.com"]
    resources  = ["redisfailovers", "redisfailovers/finalizers"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create", "get", "list", "update"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "events", "configmaps", "persistentvolumeclaims", "persistentvolumeclaims/finalizers"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }
}

resource "kubernetes_cluster_role_binding" "redis_operator" {
  depends_on = [
    kubernetes_namespace.redis
  ]

  metadata {
    name = "redis-operator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "redis-operator"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "redis-operator"
  }
}

