locals {
  region  = "eu-west-1" //region donde se desplegaran la infraestructura
  profile = "atos-integracam-tf-desarrollo-ireland" // Este valor se debe de establecer entre el equipo, porque debe configurarse el mismo para poder trabajar de forma colaborativa. Tiene el perfil con los permisos para desplegar la infraestructura
  ssh_port = "22"
  http_port = "80"
  https_port = "443"
  protocol_tcp = "tcp"
}