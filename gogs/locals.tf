locals {
  gogs_config = <<EOT
RUN_USER   = git
RUN_MODE   = prod

[server]
EXTERNAL_URL           = http://git.example.com:8280/
DOMAIN                 = git.example.com
UNIX_SOCKET_PERMISSION = 666
LOCAL_ROOT_URL         = http://git.example.com:3000/
APP_DATA_PATH          = /data
SSH_DOMAIN             = %(POD_IP)
SSH_PORT               = 2022
SSH_LISTEN_HOST        = %(POD_IP)
DB_TYPE                = postgres
HOST                   = bitnami-pg-postgresql.bitnami.svc.cluster.local:5432
NAME                   = postgres
USER                   = postgres
PASSWD                 = r8R63g6qNJ
HTTP_PORT              = 3000
DISABLE_SSH            = true
START_SSH_SERVER       = false
OFFLINE_MODE           = false

[cache]
ENABLED  = true
ADAPTER  = redis
INTERVAL = 60
HOST     = network=tcp,addr=rfr-redis-0.rfr-redis.redis.svc.cluster.local:6379
ITEM_TTL = 16h

[session]
PROVIDER        = file
PROVIDER_CONFIG = network=tcp,addr=rfr-redis-0.rfr-redis.redis.svc.cluster.local:6379

[lfs]
OBJECTS_PATH = /data/lfs-objects

[database]
TYPE     = postgres
HOST     = bitnami-pg-postgresql.bitnami.svc.cluster.local:5432
NAME     = postgres
USER     = postgres
PASSWORD = r8R63g6qNJ
SSL_MODE = disable
PATH     = /app/gogs/data/gogs.db

[repository]
ROOT = /data/git/gogs-repositories

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL     = false
DISABLE_REGISTRATION   = false
ENABLE_CAPTCHA         = true
REQUIRE_SIGNIN_VIEW    = false

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false

[log]
MODE      = console, file
LEVEL     = Info
ROOT_PATH = /app/gogs/log

[security]
INSTALL_LOCK = true
SECRET_KEY   = GzVySyGsgFaZvlE
  EOT

  init_script = <<EOT
cp /data/gogs/conf/app-pls.ini /data/gogs/conf/app.ini && chown 1000:1000 /data/gogs && chown 1000:1000 /data/gogs/conf && chown 1000:1000 /data/gogs/conf/app.ini && chown -R 1000:1000 /data/ssh
EOT
  
}

# sed -i "s/%(POD_IP)/$${POD_IP}/g" /data/gogs/conf/app.ini