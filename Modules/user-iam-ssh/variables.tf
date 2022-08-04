variable "username" {
  description = "Nombre del usuario, no usar ningun simbolo u acento a excepcion del guion y no debe superar los nueve caracteres ej srojo-ssh"
  type = string
}

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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "groups" {
  default = ["ssh", "ssh-admin"]
  type = list(string)
}
