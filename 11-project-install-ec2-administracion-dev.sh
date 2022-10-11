#K8S
cd Shared/ec2-administracion
terraform init
terraform workspace list
terraform workspace new ec2-administracion
terraform workspace select ec2-administracion
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve