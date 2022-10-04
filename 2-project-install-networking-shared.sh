#!/bin/bash
# Ejecutar proceso y pasos para la instalacion de los vpc.
# Directorio de Shared
cd Shared/Networking
terraform init
terraform workspace list
terraform workspace new networking
terraform workspace select networking
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
mkdir -p ../../Outputs/Shared
terraform output -json > ../../Outputs/Shared/networking.json