resource "kubernetes_secret" "redis" {
  metadata {
    name      = "redis"
    namespace = var.operator_namespace
  }

  data ={
    password =  ""
  }

  type = "Opaque"
}