#Global variables
variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "address_space" {
  description = "The address space that is used by the vpc."
  type        = string
}

variable "vpcName" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet-count" {}
variable "bastion_nat_subnet-count" {}
variable "private_subnet-count" {}
variable "private_lb_subnet-count" {}
variable "private_internal_subnet-count" {}
variable "nat-gw-count" {} # Numero de NAT Gateways a crear
variable "route-table-count" {}

variable "cidr_block_public_subnet" {
  description = "CIDR block of the VPC"
  type        = list
}
variable "cidr_block_bastion_nat_subnet" {
  description = "CIDR block of the VPC"
  type        = list
}
variable "cidr_block_private-subnet" {
  description = "CIDR block of the VPC"
  type        = list
}
variable "cidr_block_private-lb-subnet" {
  description = "CIDR block of the VPC"
  type        = list
}
variable "cidr_block_private-internal-subnet" {
  description = "CIDR block of the VPC"
  type        = list
}

#Se debe crear la zona dns interna
variable "CreateRoute53" {
  type        = string
  description = "true o false"
}

#Esta variable existe cuando ya esta creada una zoneid internal
variable "InternalZoneId" {
  type        = string
  description = "Este valor se necesita cuando no se debe crear una zona interna, pero se debe añadir a una ya existente"
  default     = ""
}

#Route53 internals variables
variable "Route53name" {
  type        = string
  description = "Name of the hosted zone"
}

# variable "main_vpc" {
#   type        = string
#   description = "Main VPC ID that will be associated with this hosted zone"
# }

variable "force_destroy" {
  type        = string
  default     = false
  description = "Whether to destroy all records inside if the hosted zone is deleted"
}

#Ejemplo SNIPPET para incluir mapas
# map2 = 
#   NAT= 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28	
#   INT= 10.3.0.48/28, 10.3.0.64/28, 10.3.0.80/28
#   Private1= 10.3.0.96/27, 10.3.0.128/27, 10.3.0.160/27
#   Public= 10.3.1.0/26, 10.3.1.64/26, 10.3.1.128/26
#   Private2= 10.3.1.192/26, 10.3.2.0/26, 10.3.2.64/26
