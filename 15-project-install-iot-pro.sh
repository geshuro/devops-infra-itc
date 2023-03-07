#!/bin/bash
# Ejecutar proceso y pasos para la instalacion del LoadBalancer.
# Directorio de Shared
cd Pro/iot
terraform init
terraform workspace list
terraform workspace new iot
terraform workspace select iot
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve