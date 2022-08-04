/**
* ## Descripcion Modulo
* Con este modulo lo que pretendemos es crear un mapa de redes que nos devuelva, por capas una cadena con las subnets configuradas.
* Este modulo se ha contruido para resolver mapas de redes, de forma agnostica a la cloud en la que pueda trabajar. 
* Cuando se recojan los datos, estos deberan ser tratados para poder utilizarse por cada proveedor cloud. 
*
*
* ## Configurando los provider
*
* **Provider use null**
*
* Lo utilizamos para generar recursos sin aplicacion de estado.
*
*
* ## Recursos
*
* **data "null_data_source" "subnets"**
*
*/

#provider "external" {
#  version = "~> 1.2"
#}

provider "null" {
  version = "~> 3.1"
}


data "null_data_source" "subnets" {
  # inputs = {
  #   ListSubnetsNat = join(", ", ["${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat1Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat2Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat3Netnum"])])}"])
  #   ListSubnetsPub = join(", ", ["${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub1Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub2Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub3Netnum"])])}"])
  #   ListSubnetsPr1 = join(", ", ["${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr11Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr11Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr12Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr12Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr13Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr13Netnum"])])}"])
  #   ListSubnetsPr2 = join(", ", ["${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr21Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr21Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr22Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr22Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr23Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr23Netnum"])])}"])
  #   ListSubnetsInt = join(", ", ["${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int1Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int2Netnum"])])}", "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int3Netnum"])])}"])
  # }
  inputs = {
    ListSubnetsNat1 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat1Netnum"])])}"
    ListSubnetsNat2 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat2Netnum"])])}"
    ListSubnetsNat3 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Nat3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Nat3Netnum"])])}"
    
    ListSubnetsPub1 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub1Netnum"])])}"
    ListSubnetsPub2 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub2Netnum"])])}"
    ListSubnetsPub3 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pub3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pub3Netnum"])])}"

    ListSubnetsPr11 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr11Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr11Netnum"])])}"
    ListSubnetsPr12 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr12Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr12Netnum"])])}"
    ListSubnetsPr13 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr13Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr13Netnum"])])}"

    ListSubnetsPr21 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr21Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr21Netnum"])])}"
    ListSubnetsPr22 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr22Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr22Netnum"])])}"
    ListSubnetsPr23 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Pr23Newbits"])], var.map_subneting[join("-", [var.planVPC, "Pr23Netnum"])])}"

    ListSubnetsInt1 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int1Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int1Netnum"])])}"
    ListSubnetsInt2 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int2Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int2Netnum"])])}"
    ListSubnetsInt3 = "${cidrsubnet(var.VPC-CIDR, var.map_subneting[join("-", [var.planVPC, "Int3Newbits"])], var.map_subneting[join("-", [var.planVPC, "Int3Netnum"])])}"

  }
}


