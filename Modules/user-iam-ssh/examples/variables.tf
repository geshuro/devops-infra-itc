
variable "Environment" {
  type        = string
  description = "Referencia al entorno dev,qa,test,staging,pro,pre"
}

variable "ProjectId" {
  type        = string
  description = "pid- Identificador unico para el proyecto, este numero podemos asociarlo posteriormente con un nombre"
}

variable "CostCenter" {
  type        = string
  description = "cc- Identificador, para los tags y resolucion de costes"
}

variable "ServiceId" {
  type        = string
  description = "sid- Identificador unico del servicio"
}

variable "stage" {
  type        = string
  description = "Referencia al entorno dev,qa,test,staging,pro,pre puede ser distinto a environment"
}
variable "ssh_public_key_path" {
  type        = string
  description = "Path para almacenar los SSH public key directory (e.g. `/secrets`)"
}

variable "generate_ssh_key" {
  type        = bool
  description = "Si es `true`, se crea una nueva key pair"
}

variable "groups" {
  default = ["ssh"]
  type = list(string)
}
# variable "tags" {
#   type        = map(string)
#   description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
# }

# variable "map_username" {
#   default = {
#   "0" = "user1-ssh"
#   "1" = "user2-ssh"
#   type = map(string)
#   description = "Tabla de usuarios con permisos de ssh y openvpn"
# }