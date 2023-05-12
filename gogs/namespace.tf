resource "kubernetes_namespace" "gogs" {
  metadata {
    name = var.namespace
  }
}