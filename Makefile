# perform a terraform init 
init_%:
	@pushd Environment/$* && terraform init && popd

# terraform plan
plan_%:
	@pushd Environment/$* && terraform plan -var acr_name=$(shell cd Environment/Shared && terraform output acr_name && cd ../..) && popd

# terraform output
output_%:
	@pushd Environment/$* && terraform output && popd

# terraform apply
apply_%:
	@pushd Environment/$* && terraform apply -auto-approve && popd

# terraform destroy
destroy_%:
	@pushd Environment/$* && terraform destroy -auto-approve -var acr_name=$(shell cd Environment/Shared && terraform output acr_name && cd ../..) && popd

# terraform destroy all
destroy_all:
# destroy all environments Shared, Day1, Day2 with calling destroy_% target
	@$(MAKE) destroy_Day2
	@$(MAKE) destroy_Day1
	@$(MAKE) destroy_Shared

# do an az aks get-credentials with the terraform output of day2, aks_name and aks_rg
aks_get_credentials:
	@az aks get-credentials --name $(shell cd Environment/Day2 && terraform output aks_name) --resource-group $(shell cd Environment/Day2 && terraform output aks_rg)

# apply all files from Environment/Day2/k8s_init
k8s_init:
	@kubectl apply -f Environment/Day2/k8s_init

# create a helm package for Evinronment/Day2/aci-hello and push to the acr with the terraform output of day2, acr_name
helm_package:
	@helm package Environment/Day2/aci-hello
	@helm push $(shell cd Environment/Day2 && terraform output acr_name) aci-hello-0.1.0.tgz

