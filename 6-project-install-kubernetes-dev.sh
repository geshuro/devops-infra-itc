#K8S
cd Dev/Kubernetes-centos
terraform init
terraform workspace list
terraform workspace new kubernetes-dev
terraform workspace select kubernetes-dev
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve