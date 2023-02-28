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

export admin_object_id_list=$(ADMIN_OBJECT_IDS)
apply_Day2:
	@pushd Environment/Day2 && terraform apply -auto-approve -var acr_name=$(shell cd Environment/Shared && terraform output acr_name && cd ../..) -var aad_admin_group_object_ids=$(admin_object_id_list) && popd

# terraform destroy
destroy_%:
	@pushd Environment/$* && terraform destroy -lock=false -auto-approve -var acr_name=$(shell cd Environment/Shared && terraform output acr_name && cd ../..) && popd

destroy_Day2:
	@pushd Environment/Day2 && terraform destroy -lock=false -auto-approve -var acr_name=$(shell cd Environment/Shared && terraform output acr_name && cd ../..) -var aad_admin_group_object_ids=$(admin_object_id_list) && popd

destroy_Shared:
	@pushd Environment/Shared && terraform destroy -auto-approve && popd

build_day2:
	@$(MAKE) init_Shared
	@$(MAKE) apply_Shared
	@$(MAKE) init_Day2
	@$(MAKE) apply_Day2
	@$(MAKE) aks_get_credentials
	@$(MAKE) .acr_build
	@$(MAKE) helm_package
	@$(MAKE) install_argocd
	@$(MAKE) k8s_init

# terraform destroy all
destroy_all:
# destroy all environments Shared, Day1, Day2 with calling destroy_% target
	@echo "Destroy day2"
	@$(MAKE) destroy_Day2
	@echo "Destroy day1"
	@$(MAKE) destroy_Day1
	@echo "Destroy shared"
	@$(MAKE) destroy_Shared

# do an az aks get-credentials with the terraform output of day2, aks_name and aks_rg
aks_get_credentials:
	@az aks get-credentials --name $(shell cd Environment/Day2 && terraform output aks_name) --resource-group $(shell cd Environment/Day2 && terraform output aks_rg)

# apply all files from Environment/Day2/k8s_init
k8s_init:
	yq -i '. | select(.stringData | has("password")) .stringData.password = $(shell cd Environment/Shared && terraform output acr_password)' Environment/Day2/k8s_init/argocd-repositories.yaml
	yq -i '. | select(.stringData | has("password")) .stringData.username = $(shell cd Environment/Shared && terraform output acr_username)' Environment/Day2/k8s_init/argocd-repositories.yaml
	yq -i '. | select(.stringData | has("password")) .stringData.url = $(shell cd Environment/Shared && terraform output acr_login_server)' Environment/Day2/k8s_init/argocd-repositories.yaml
	@kubectl apply -f Environment/Day2/k8s_init

# login to helm repository with the terraform output of shared, acr_login_server
.helm_login:
	echo "Login to Helm"
	@helm registry login $(shell cd Environment/Shared && terraform output acr_login_server) --username $(shell cd Environment/Shared && terraform output acr_username) --password $(shell cd Environment/Shared && terraform output acr_password)

# create a helm package for Code/Day2/aci-hello and push to the acr with the terraform output of day2, acr_name
helm_package:
	echo "Create Helm Package"
	@helm package Code/Day2/aci-hello
	$(MAKE) .helm_login
	@helm push aci-hello-0.1.1.tgz oci://$(shell cd Environment/Shared && terraform output acr_login_server) 

# acr build container
.acr_build:
	@az acr build --registry $(shell cd Environment/Shared && terraform output acr_name) --image aci-hello:latest Code/Day1/BuildContainerDemo/

install_argocd:
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace
