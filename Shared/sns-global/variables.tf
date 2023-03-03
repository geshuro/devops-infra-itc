
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

variable "sns_topic_name" {
  type        = string
  description = "Nombre de la subcripcion"
}

variable "sns_subscription_emails" {
  type        = string
  description = "Lista de email seperados por espacios"
} 