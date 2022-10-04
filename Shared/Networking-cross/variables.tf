variable "Environment" {
  type        = string
  description = "Tipo de entorno, dev, qa,test, pre, pro"
  #default     = "dev"
}

variable "CostCenter" {
  type        = string
  description = "Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Atos"
  #default     = "TTAA"
}
variable "CostCenterId" {
  type        = string
  description = "Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4"
  #default     = "TTAA"
}
variable "ServiceId" {
  type        = string
  description = "Identificador unico de servicio provisto por uuid4"
  #default     = "TTAA-ARQREF"
}
variable "ProjectId" {
  type        = string
  description = "Identificador Unico de proyecto provisto por uuid4"
  #default     = "apimicroservice"
}

variable "amazon_side_asn" {
  type        = number
  description = "Numero de asn entre "
  #default     = "apimicroservice"
}

variable "AWSprofileBackend" {
  type        = string
  description = "Nombre del perfil configurado en .aws/credentials"
  #default     = "sunat-cuc"
}

variable "s3backend" {
  type        = string
  description = "Nombre del bakend"
  #default     = "apimicroservice"
}
variable "regionbackend" {
  type        = string
  description = "Region situado el backend"
  #default     = "apimicroservice"
}
variable "sharedkeybackend" {
  type        = string
  description = "Path del backend"
  #default     = "apimicroservice"
}
variable "devkeybackend" {
  type        = string
  description = "Path del backend"
  #default     = "apimicroservice"
}
variable "releasekeybackend" {
  type        = string
  description = "Path del backend"
  #default     = "apimicroservice"
}
variable "Encryptacionbackend" {
  type        = bool
  description = "Estado de la encriptacion del backend"
  default     = true
}
variable "DynamoDBbackend" {
  type        = string
  description = "Nombre tabla de dynamodb gestion terraform"
  default     = true
}
