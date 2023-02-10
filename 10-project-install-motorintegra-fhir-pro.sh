#K8S
cd Pro/FHIR-windowserver2019
terraform init
terraform workspace list
terraform workspace new fhir
terraform workspace select fhir
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve