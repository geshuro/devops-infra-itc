### Variables Generales ####
variable "s3backend" {
  description = "Nombre del bucket configurado para el backend"
  type = string
}

variable "s3devops" {
  description = "Nombre del bucket configurado para el las configuraciones aplicaciones"
  type = string
}

variable "dynamobackend" {
  description = "Nombre de la tabla de dynamodb para el backend"
  type = string
}

variable "regionbackend" {
  description = "Nombre de la region del backend"
  type = string
}

variable "profilebackend" {
  description = "Nombre del profile con permisos de acceso al backend"
  type = string
}

/* imendozah
variable "EnvironmentbackendShared" {
  description = "Nombre del profile con permisos de acceso al backend"
  type = string
}*/

variable "Environment" {
  type        = string
  description = "Tipo de entorno, dev, qa,test, pre, pro"
  #default     = "shared"
}

variable "CostCenter" {
  type        = string
  description = "Centro de coste aplicado a la cuenta, servicio o proyecto"
}

variable "CostCenterId" {
  type        = string
  description = "Identificador del centro de coste aplicado a la cuenta, servicio o proyecto"
}
 
variable "ServiceId" {
  type        = string
  description = "Identificador unico de servicio"
}
variable "ProjectId" {
  type        = string
  description = "Identificador Unico de proyecto"
}

variable "stage" {
  type        = string
  description = "Referencia al entorno dev,qa,test,staging,pro,pre puede ser distinto a environment"
}

variable "name" {
  type        = string
  description = "Nombre de la aplicacion o elemento que queremos generar"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path para almacenar los SSH public key directory (e.g. `/secrets`)"
}

variable "generate_ssh_key" {
  type        = bool
  description = "Si es `true`, se crea una nueva key pair"
}

variable "instance_type" {
    type = string
    description = "Instance type to make the Bastion host from"
    default     = "t3.medium"
}

variable "account_canonical_ubuntu" {
    type = string
    description = "Account AWS Canonical"
    default = "099720109477" 
}

variable "AutoStart" {
  description = "Add Stop/Start via cron Cloudwacht"
  type = bool
  default = false
}