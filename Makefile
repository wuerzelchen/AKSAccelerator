# perform a terraform init 
init_%:
	@pushd Environment/$* && terraform init && popd

# terraform plan
plan_%:
	@pushd Environment/$* && terraform plan && popd

# terraform output
output_%:
	@pushd Environment/$* && terraform output && popd

# terraform apply
apply_%:
	@pushd Environment/$* && terraform apply && popd

# terraform destroy
destroy_%:
	@pushd Environment/$* && terraform destroy && popd

# terraform destroy all
destroy_all:
# destroy all environments Shared, Day1, Day2 with calling destroy_% target
	@$(MAKE) destroy_Shared
	@$(MAKE) destroy_Day1
	@$(MAKE) destroy_Day2

# do an az aks get-credentials with the terraform output of day2, aks_name and aks_rg
aks_get_credentials:
	@az aks get-credentials --name $(shell cd Environment/Day2 && terraform output aks_name) --resource-group $(shell cd Environment/Day2 && terraform output aks_rg)

# apply all files from Environment/Day2/k8s_init
k8s_init:
	@kubectl apply -f Environment/Day2/k8s_init