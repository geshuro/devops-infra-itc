#!/bin/bash
# Ejecutar proceso y pasos para la instalacion del bastion.
# Directorio de Shared
cd Shared/bastion
terraform init
terraform workspace list
terraform workspace new bastion
terraform workspace select bastion
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve