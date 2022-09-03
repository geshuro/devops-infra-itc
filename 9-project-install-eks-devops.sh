#K8S
export KUBE_CONFIG_PATH=~/.kube/config
#Para ejecutar helmchart con terraform
cd Shared/EKS
terraform init
terraform workspace list
terraform workspace new eks-devops
terraform workspace select eks-devops
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars -auto-approve
terraform destroy -var-file=variables.tfvars -auto-approve