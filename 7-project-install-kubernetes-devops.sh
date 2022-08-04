#K8S
cd Shared/Kubernetes-devops-centos
terraform init
terraform workspace list
terraform workspace new kubernetes-devops
terraform workspace select kubernetes-devops
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve