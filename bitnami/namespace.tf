resource "kubernetes_namespace" "bitnami" {
  metadata {
    name = var.namespace
  }
}