#!/bin/bash
# Ejecutar proceso y pasos para la instalacion de los vpc.
# Directorio de Dev
cd Dev/Networking
terraform init
terraform workspace list
terraform workspace new networking
terraform workspace select networking
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
mkdir -p ../../Outputs/Dev
terraform output -json > ../../Outputs/Dev/networking.json