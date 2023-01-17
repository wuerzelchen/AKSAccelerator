# Intro
This Repo is for contents of the AKS Accelerator
You find different Environments in this directory.
First, you need to go to [Shared](#shared) and execute the steps mentioned below. After that, you can decide if you want to move to Day1

## Shared
This needs to be done, before you do anything of Day 1 or Day 2.
Navigate to ./Environment/Shared/, open a terminal and execute the following commands:
1. Init terraform with `terraform init`
2. Terraform apply `terraform apply`
3. Save terraform output into variables
    - Bash:
        - `acr_name=$(terraform output -raw acr_name)`
        - `resource_group_name=$(terraform output -raw resource_group_name)`
    - Powershell: 
        - `$acr_name = (& terraform output -raw acr_name)`
        - `$resource_group_name = (& terraform output -raw resource_group_name)`
4. Import container into acr
    - Bash & Powershell:
        - `az acr import --name "$acr_name" --resource-group "$resource_group_name" --source mcr.microsoft.com/azuredocs/aci-helloworld --image aci-helloworld`


## Day 1
Navigate to ./Environment/Day1/, open a terminal and execute the following commands:
1. Initialise terraform with `terraform init`
2. Apply everything to your environment with `terraform apply -var acr_name=$acr_name`

## Day 2
Navigate to ./Environment/Day2/, open a terminal and execute the following commands:
1. Initialise terraform with `terraform init`
2. Apply everything to your environment
    - Bash & Powershell: 
        - `terraform apply -var acr_name=$acr_name`
3. Save terraform output into variables
    - Bash
        - `aks_name=$(terraform output -raw aks_name)`
    - Powershell:
        - `$aks_name = (& terraform output -raw aks_name)`
4. Log in to your fresh aks cluster
    - Bash & Powershell:
        - `az aks get-credentials -n $aks_name -g $resource_group_name`
5. Install your aci-helloworld to the cluster with `helm install aci-helloworld ./aci-hello -f aci-hello/values.yaml --set image.repository=acrtest1dfsa23.azurecr.io/aci-helloworld --set image.tag=latest`