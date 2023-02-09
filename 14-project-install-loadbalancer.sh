#!/bin/bash
# Ejecutar proceso y pasos para la instalacion del LoadBalancer.
# Directorio de Shared
cd Shared/LoadBalancer
terraform init
terraform workspace list
terraform workspace new loadbalancer
terraform workspace select loadbalancer
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve