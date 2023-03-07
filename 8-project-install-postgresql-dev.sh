#K8S
cd Dev/PostgreSQL-centos
terraform init
terraform workspace list
terraform workspace new postgresql-dev
terraform workspace select postgresql-dev
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve