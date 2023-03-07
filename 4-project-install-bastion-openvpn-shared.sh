#!/bin/bash
# Ejecutar proceso y pasos para la instalacion del bastion.
# Directorio de Shared
cd Shared/opt/IAM-SSH-OPENVPN/
terraform init
terraform workspace list
terraform workspace new opt-iam-ssh-openvpn
terraform workspace select opt-iam-ssh-openvpn
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve