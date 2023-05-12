resource "kubernetes_persistent_volume_claim" "gogs_volume_claim" {

  depends_on = [
    kubernetes_namespace.gogs
  ]

  metadata {
    name      = "gogs-data"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "standard"
  }
}

# resource "kubernetes_persistent_volume" "gogs_volume" {
  
#   depends_on = [
#     kubernetes_namespace.gogs
#   ]

#   metadata {
#     name = "gogs-data"
#   }
#   spec {
#     capacity = {
#       storage = "2Gi"
#     }
#     access_modes = ["ReadWriteMany"]
#     persistent_volume_source {
#         host_path {
#           path = "/data/gogs"
#         }
#     }
#   }
# }