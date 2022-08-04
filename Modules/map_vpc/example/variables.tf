variable VPC-CIDR {
  description = "Cidr asignado al VPC y del que partimos para generar las subnets"
  #default = "10.3.0.0/22"
}

variable planVPC {
  description = "Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan default. Atiende al nombre de cabecera dado a los mapas de red"
  #default = "Mask22-Int"
}


