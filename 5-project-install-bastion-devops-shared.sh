#!/bin/bash
# Ejecutar proceso y pasos para la instalacion del bastion.
# Directorio de Shared
cd Shared/bastion-devops
terraform init
terraform workspace list
terraform workspace new bastion-devops
terraform workspace select bastion-devops
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve