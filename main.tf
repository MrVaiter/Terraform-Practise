module "redis_operator_crds" {
  source = "./redis-operator/crds"
}

module "bitnami" {
  source = "./bitnami"
}

module "redis_operator" {
  source = "./redis-operator"
  depends_on = [module.redis_operator_crds]
}

module "gogs" {
  source = "./gogs"

  depends_on = [
      module.bitnami,
      module.redis_operator
  ]
}