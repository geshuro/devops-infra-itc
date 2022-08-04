variable "destinoVPCId" {
    type            =  string
    description     =  "VPC Id de destino de la conexion peering"
}

variable "origenVPCId" {
    type            = string
    description     = "VPC Id de origen de la conexion peering"
}
variable "DescriptionVPCPeering" {
    type            = string
    description     = "Descripcion de la conexion origen destino"
}

variable "VPCPeeringEnable" {
    type            = string
    description     = "Condicionador si debe crearse el recurso true o false"
    default         = "false"
}
