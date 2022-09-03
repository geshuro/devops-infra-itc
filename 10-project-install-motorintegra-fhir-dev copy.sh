#K8S
cd Dev/FHIR-windowserver2019
terraform init
terraform workspace list
terraform workspace new fhir-dev
terraform workspace select fhir-dev
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve