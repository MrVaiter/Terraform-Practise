resource "kubernetes_deployment" "gogs_gogs" {
  depends_on = [
    kubernetes_namespace.gogs,
    kubernetes_persistent_volume_claim.gogs_volume_claim
  ]
  metadata {
    name      = "gogs-gogs"
    namespace = var.namespace
    labels = {
      app = "gogs-gogs"

      chart = "gogs-0.1.3"

      heritage = "Helm"

      release = "gogs"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gogs-gogs"
      }
    }

    template {
      metadata {
        labels = {
          app = "gogs-gogs"
        }
      }

      spec {
        volume {
          name = "gogs-data"
          persistent_volume_claim {
            claim_name = "gogs-data"
          }
        }

        volume {
          name = "postgres-data"
          empty_dir {}
        }

        volume {
          name = "gogs-config"

          config_map {
            name = "gogs-gogs"
          }
        }

        # init_container {
        #   name    = "init"
        #   image   = "gogs/gogs:0.12.3"
        #   command = ["/bin/sh", "-c", "mkdir -p /datatmp/gogs/conf\nif [ ! -f /datatmp/gogs/conf/app.ini ]; then\n  "]

        #   volume_mount {
        #     name       = "gogs-data"
        #     mount_path = "/datatmp"
        #   }

        #   volume_mount {
        #     name       = "gogs-config"
        #     mount_path = "/etc/gogs"
        #   }

        #   image_pull_policy = "IfNotPresent"
        # }

        # init_container {
        #   name    = "create-subpath"
        #   image   = "busybox:1.32.0"
        #   command = ["/bin/sh"]
        #   args    = ["-c", "mkdir -p /var/lib/postgresql/data/pgdata/postgresql-db;"]

        #   volume_mount {
        #     name       = "postgres-data"
        #     mount_path = "/var/lib/postgresql/data/pgdata"
        #   }

        #   image_pull_policy = "IfNotPresent"
        # }

        init_container {
          name    = "change-permission-of-directory"
          image   = "gogs/gogs:0.13"
          command = ["/bin/sh"]
          args    = ["-c", local.init_script]

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }

          volume_mount {
            name       = "gogs-data"
            mount_path = "/data"
            read_only  = false
          }

          volume_mount {
            name       = "gogs-config"
            mount_path = "/data/gogs/conf/app-pls.ini"
            sub_path   = "app-pls.ini"
          }

          image_pull_policy = "IfNotPresent"
        }

        security_context {
          fs_group = 1000
        }

        container {
          name  = "gogs"
          image = "gogs/gogs:0.13"

          port {
            name           = "ssh"
            container_port = 2022
          }

          port {
            name           = "http"
            container_port = 3000
          }

          env {
            name  = "GOGS_CUSTOM"
            value = "/data/gogs"
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = "gogs-db"
                key  = "dbPassword"
              }
            }
          }

          resources {
            limits = {
              cpu = "1"

              memory = "2Gi"
            }

            requests = {
              cpu = "1"

              memory = "500Mi"
            }
          }

          volume_mount {
            name       = "gogs-data"
            mount_path = "/data"
            read_only  = false
          }

          volume_mount {
            name       = "gogs-config"
            mount_path = "/data/gogs/conf/app-pls.ini"
            sub_path   = "app-pls.ini"
          }

          liveness_probe {
            tcp_socket {
              port = "http"
            }

            initial_delay_seconds = 200
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 10
          }

          readiness_probe {
            tcp_socket {
              port = "http"
            }

            initial_delay_seconds = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"
        }

        # container {
        #   name    = "memcached"
        #   image   = "memcached:1.5.19-alpine"
        #   command = ["memcached", "-m 64", "-o", "modern", "-v"]

        #   port {
        #     name           = "memcache"
        #     container_port = 11211
        #   }

        #   resources {
        #     requests = {
        #       cpu = "50m"

        #       memory = "64Mi"
        #     }
        #   }

        #   liveness_probe {
        #     tcp_socket {
        #       port = "memcache"
        #     }

        #     initial_delay_seconds = 30
        #     timeout_seconds       = 5
        #   }

        #   readiness_probe {
        #     tcp_socket {
        #       port = "memcache"
        #     }

        #     initial_delay_seconds = 5
        #     timeout_seconds       = 1
        #   }

        #   image_pull_policy = "IfNotPresent"

        #   security_context {
        #     run_as_user = 1000
        #   }
        # }
      }
    }
  }
}

