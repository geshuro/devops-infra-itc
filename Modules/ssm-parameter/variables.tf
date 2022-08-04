variable "name" {
  type        = string
  default     = ""
  description = "Nombre del path ssm parameter"
}

variable "description" {
  type        = string
  default     = ""
  description = "Descripcion del ssm parameter"
}

variable "type" {
  type        = string
  default     = ""
  description = "String, StringList and SecureString"
}

variable "tags" {
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "value" {
  type        = string
  default     = ""
  description = "Valor de cadena que vamos a guardar"
}