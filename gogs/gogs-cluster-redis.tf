resource "kubernetes_manifest" "redisfailover_cluster_redis" {

  manifest = {
    "apiVersion" = "databases.spotahome.com/v1"
    "kind"       = "RedisFailover"
    "metadata" = {
      "name"      = "redis"
      "namespace" = var.operator_namespace
    }
    "spec" = {
      "redis" = {
         "exporter" = {
          "enabled" = true
          "image"   = "leominov/redis_sentinel_exporter:1.3.0"
          "args"=[
          "--web.telemetry-path",
           "/metrics"
          ]

      "env"=[{

    "name"= "REDIS_EXPORTER_LOG_FORMAT"
      "value"= "txt"
         }]

        }
        "extraVolumeMounts" = [
          {
            "mountPath" = "/etc/redis"
            "name"      = "redis"
            "readOnly"  = true
          },
        ]
        "extraVolumes" = [
          {
            "name" = "redis"
            "secret" = {
              "optional"   = false
              "secretName" = "redis"
            }
          },
        ]
        "replicas" = 3
      }
      "sentinel" = {
        "exporter" = {
          "enabled" = true
          "image"   = "leominov/redis_sentinel_exporter:1.3.0"
        }
        "extraVolumeMounts" = [
          {
            "mountPath" = "/etc/redis"
            "name"      = "redis"
            "readOnly"  = true
          },
        ]
        "extraVolumes" = [
          {
            "name" = "redis"
            "secret" = {
              "optional"   = false
              "secretName" = "redis"
            }
          },
        ]
        "replicas" = 3
      }
    }
  }


#   yaml_body = <<EOT
# apiVersion: databases.spotahome.com/v1
# kind: RedisFailover
# metadata:
#   name: redis-manifest
#   namespace: ${var.operator_namespace}
# spec:
#   sentinel:
#     replicas: 3
#     extraVolumes:
#     - name: redis
#       secret:
#         secretName: redis-name
#         optional: false
#     extraVolumeMounts:
#     - name: redis
#       mountPath: "/etc/redis"
#       readOnly: true
#   redis:
#     replicas: 3
#     extraVolumes:
#     - name: redis
#       secret:
#         secretName: redis-name
#         optional: false
#     extraVolumeMounts:
#     - name: redis
#       mountPath: "/etc/redis"
#       readOnly: true
#   EOT

depends_on = [
  kubernetes_namespace.gogs,
]

}
