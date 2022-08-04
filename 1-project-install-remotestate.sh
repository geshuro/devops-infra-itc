#!/bin/bash
# Ejecutar proceso y pasos para creacion del remote state.
cd Remotetfstate
terraform init
terraform plan
terraform apply -auto-approve
