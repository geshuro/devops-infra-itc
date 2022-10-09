locals {
  region  = "eu-west-1" //region donde se desplegaran la infraestructura
  profile = "atos-integracam-tf-desarrollo-ireland" //El perfil cuenta con los permisos para desplegar la infraestructura

  cluster_name = "eks-devops-${random_string.suffix.result}"

  tags = {
    Name         = local.cluster_name
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  } 
}