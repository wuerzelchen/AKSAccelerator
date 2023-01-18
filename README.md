# Intro
This Repo is for contents of the AKS Accelerator
You find different Environments in this directory.
First, you need to go to [Shared](#shared) and execute the steps mentioned below. After that, you can decide if you want to move to Day1

## Shared
This needs to be done, before you do anything of Day 1 or Day 2
1. init terraform with `terraform init`
2. terraform apply `terraform apply`
3. import container `az acr import -n acrtest1dfsa23 --source mcr.microsoft.com/azuredocs/aci-helloworld --image aci-helloworld`

## Day 1
1. initialise terraform with `terraform init`
2. apply everything to your environment with `terraform apply`

## Day 2
1. initialise terraform with `terraform init`
2. apply everything to your environment with `terraform apply`
3. log in to your fresh aks cluster with `az aks get-credentials -n aks -g rg`
4. install your aci-helloworld to the cluster with `helm install aci-helloworld ./aci-hello -f aci-hello/values.yaml --set image.repository=acrtest1dfsa23.azurecr.io/aci-helloworld --set image.tag=latest`
5. install argocd
  - `helm repo add argocd https://argoproj.github.io/argo-helm`
  - `helm install argocd argo/argo-cd`
6. access argocd
  - `kubectl port-forward service/argocd-server -n default 8080:443`
  - get the secret with `kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
  - go to your browser and type [https://localhost:8080](https://localhost:8080)
    for the username use `admin` and the password is the one you got from the step before. Copy it without the `%` at the end