locals {
  region  = "us-east-1" //region donde se desplegaran la infraestructura
  profile = "atos-integracam-tf-desarrollo" // Este valor se debe de establecer entre el equipo, porque debe configurarse el mismo para poder trabajar de forma colaborativa. Tiene el perfil con los permisos para desplegar la infraestructura
  ssh_port = "22"
  protocol_tcp = "tcp"
  kubernetes_api_server_port = "6443"
}