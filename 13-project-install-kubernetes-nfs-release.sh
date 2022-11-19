#K8S
cd Release/Kubernetes-nfs-centos
terraform init
terraform workspace list
terraform workspace new kubernetes-nfs
terraform workspace select kubernetes-nfs
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve