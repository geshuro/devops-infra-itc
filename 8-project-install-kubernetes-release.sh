#K8S
cd Release/Kubernetes-centos
terraform init
terraform workspace list
terraform workspace new kubernetes
terraform workspace select kubernetes
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve