# Intro
This Repo is for contents of the AKS Accelerator
You find different Environments in this directory.
First, you need to go to [Shared](#shared) and execute the steps mentioned below. After that, you can decide if you want to move to Day1

## Shared
1. init terraform with `terraform init`
2. terraform apply `terraform apply`
3. import container `az acr import -n acrtest1dfsa23 --source mcr.microsoft.com/azuredocs/aci-helloworld --image aci-helloworld`

## Day 1
First steps first:
1. initialise terraform with `terraform init`
2. apply everything to your environment with `terraform apply`