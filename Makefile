run:
	@terraform apply -auto-approve

run_all:
	@terraform apply -target module.redis_operator_crds -auto-approve
	@terraform apply -auto-approve

crds:
	@terraform apply -target module.redis_operator_crds -auto-approve

destroy:
	@terraform destroy -target module.gogs -auto-approve
	@terraform destroy -target module.bitnami -auto-approve
	@terraform destroy -target module.redis_operator -auto-approve

destroy_all:
	@terraform destroy -auto-approve

restart:
	@terraform destroy -target module.redis_operator -auto-approve
	@terraform destroy -target module.bitnami -auto-approve
	@terraform destroy -target module.gogs -auto-approve

	@terraform apply -auto-approve