variable "vpcCIRD" {
  type        = string
  description = "El CIRD asignado al VPC, se establece con una mascara de red no superior de una /24 y no inferior de una /16"
  #default     = "10.20.8.0/22"
}

variable "vpcName" {
  type        = string
  description = "Nombre del VPC"
  #default    = "vpcdev"
}

variable "Maskplan" {
  type        = string
  description = "En base al CIRD proporcionado, seleccionar un plan de subnetting Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan #default. Atiende al nombre de cabecera dado a los mapas de red"
  #default     = "Mask22"
}

variable "CreateRoute53" {
  type        = string
  description = "Se crea la zona internal DNS"
}

variable "DNSInternalName" {
  type        = string
  description = "El nombre que recibe la zona interna, se puede atomatizar, pero funcionalmente y por operacion se considera dejarla de forma manual"
  #default     = "arqref.ttaa.int"
}

variable "Environment" {
  type        = string
  description = "Tipo de entorno sh, dev, qa, test, pre, pro"
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