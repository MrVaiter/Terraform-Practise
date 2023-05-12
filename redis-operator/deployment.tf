resource "kubernetes_deployment" "redis_operator" {
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
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "redis-operator"

        "app.kubernetes.io/name" = "redis-operator"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "redis-operator"

          "app.kubernetes.io/name" = "redis-operator"
        }
      }

      spec {
        container {
          name  = "redis-operator"
          image = "quay.io/spotahome/redis-operator:v1.2.4"

          port {
            name           = "metrics"
            container_port = 9710
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu = "100m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "128Mi"
            }
          }

          liveness_probe {
            tcp_socket {
              port = "9710"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            tcp_socket {
              port = "9710"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user               = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        service_account_name = "redis-operator"
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}

