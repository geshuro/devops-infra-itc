#!/bin/bash
# Ejecutar proceso y pasos para la instalacion de los vpc.
# Directorio de Shared
cd Shared/Networking-cross
terraform init
terraform workspace list
terraform workspace new networking-cross
terraform workspace select networking-cross
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve