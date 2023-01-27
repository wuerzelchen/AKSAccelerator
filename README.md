# Intro
This Repo is for contents of the AKS Accelerator
You find different Environments in this directory.
First, you need to go to [Shared](#shared) and execute the steps mentioned below. After that, you can decide if you want to move to Day1

## Shared
This needs to be done, before you do anything of Day 1
1. init terraform with `terraform init`
2. terraform apply `terraform apply`
3. import container `az acr import -n acrtest1dfsa23 --source mcr.microsoft.com/azuredocs/aci-helloworld --image aci-helloworld`

## Day 1
1. initialise terraform with `terraform init`
2. apply everything to your environment with `terraform apply`

## Day 2
1. run `make build_day2` in the repo folder, where the Makefile is in
2. at the end, there is an output from argocd how you access it and how you get the credentials
3. change to the correct ACR registry in your `App of Apps Repository`in this example it will be the `project-development-dev` repository