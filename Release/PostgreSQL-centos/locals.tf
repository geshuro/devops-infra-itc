locals {
  region  = "eu-west-1" //region donde se desplegaran la infraestructura
  profile = "atos-integracam-tf-desarrollo-ireland" // Este valor se debe de establecer entre el equipo, porque debe configurarse el mismo para poder trabajar de forma colaborativa. Tiene el perfil con los permisos para desplegar la infraestructura
  ssh_port = "22"
  protocol_tcp = "tcp"
  postgresql_read_write_port = "5000" // port 5000 (read / write) master
  postgresql_read_port = "5001" // port 5001 (read only) all replicas
}