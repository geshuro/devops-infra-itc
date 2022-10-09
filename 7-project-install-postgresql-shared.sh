#K8S
cd Shared/PostgreSQL-centos
terraform init
terraform workspace list
terraform workspace new postgresql
terraform workspace select postgresql
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve