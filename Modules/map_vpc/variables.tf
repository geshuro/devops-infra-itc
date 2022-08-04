variable "VPC-CIDR" {
  description = "Cidr asignado al VPC y del que partimos para generar las subnets"
  #default = "10.3.0.0/22"
}

#variable "ListMap" {
#    description = "Lista de posibles map de redes ["Mask21", "Mask22", "Mask23", "Mask24", "Mask22-Int"] Mask22 es el plan default."
#    default = ["Mask21", "Mask22", "Mask23", "Mask24", "Mask22-Int"]
#}

variable planVPC {
  description = "Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan default. Atiende al nombre de cabecera dado a los mapas de red"
  #default = "Mask22-Int"
}

# No modificar, se puede añadir otros mapas, para ser mas especificos de proyecto, pero no eliminar o modificar los valores actuales.
variable "map_subneting" {
  # Configuracion de los mapas segun su funcion.
  description = "Configuracion de los mapas segun su funcion. Utilizamos la funcion cidrsubnet (newbits(Indica el numero en el array, de los modelos de subnet que existen dentro del CIDR dado), netnum(Nos indica el numero dentro del array de extraer todas las subnet indicadas en el newbits))"
  default = {
    # Map Network /22
    "Mask22-Nat1Newbits" = 6
    "Mask22-Nat1Netnum"  = 0
    "Mask22-Nat2Newbits" = 6
    "Mask22-Nat2Netnum"  = 1
    "Mask22-Nat3Newbits" = 6
    "Mask22-Nat3Netnum"  = 2

    "Mask22-Pub1Newbits" = 4
    "Mask22-Pub1Netnum"  = 5
    "Mask22-Pub2Newbits" = 4
    "Mask22-Pub2Netnum"  = 6
    "Mask22-Pub3Newbits" = 4
    "Mask22-Pub3Netnum"  = 7

    "Mask22-Pr11Newbits" = 5
    "Mask22-Pr11Netnum"  = 4
    "Mask22-Pr12Newbits" = 5
    "Mask22-Pr12Netnum"  = 5
    "Mask22-Pr13Newbits" = 5
    "Mask22-Pr13Netnum"  = 6

    "Mask22-Pr21Newbits" = 4
    "Mask22-Pr21Netnum"  = 8
    "Mask22-Pr22Newbits" = 4
    "Mask22-Pr22Netnum"  = 9
    "Mask22-Pr23Newbits" = 4
    "Mask22-Pr23Netnum"  = 10

    "Mask22-Int1Newbits" = 6
    "Mask22-Int1Netnum"  = 3
    "Mask22-Int2Newbits" = 6
    "Mask22-Int2Netnum"  = 4
    "Mask22-Int3Newbits" = 6
    "Mask22-Int3Netnum"  = 5

    # Map Network /21

    "Mask21-Nat1Newbits" = 7
    "Mask21-Nat1Netnum"  = 0
    "Mask21-Nat2Newbits" = 7
    "Mask21-Nat2Netnum"  = 1
    "Mask21-Nat3Newbits" = 7
    "Mask21-Nat3Netnum"  = 2

    "Mask21-Pub1Newbits" = 4
    "Mask21-Pub1Netnum"  = 2
    "Mask21-Pub2Newbits" = 4
    "Mask21-Pub2Netnum"  = 3
    "Mask21-Pub3Newbits" = 4
    "Mask21-Pub3Netnum"  = 4

    "Mask21-Pr11Newbits" = 4
    "Mask21-Pr11Netnum"  = 5
    "Mask21-Pr12Newbits" = 4
    "Mask21-Pr12Netnum"  = 6
    "Mask21-Pr13Newbits" = 4
    "Mask21-Pr13Netnum"  = 7

    "Mask21-Pr21Newbits" = 3
    "Mask21-Pr21Netnum"  = 4
    "Mask21-Pr22Newbits" = 3
    "Mask21-Pr22Netnum"  = 5
    "Mask21-Pr23Newbits" = 3
    "Mask21-Pr23Netnum"  = 6

    "Mask21-Int1Newbits" = 5
    "Mask21-Int1Netnum"  = 1
    "Mask21-Int2Newbits" = 5
    "Mask21-Int2Netnum"  = 2
    "Mask21-Int3Newbits" = 5
    "Mask21-Int3Netnum"  = 3

    # Map Network /23
    "Mask23-Nat1Newbits" = 5
    "Mask23-Nat1Netnum"  = 0
    "Mask23-Nat2Newbits" = 5
    "Mask23-Nat2Netnum"  = 1
    "Mask23-Nat3Newbits" = 5
    "Mask23-Nat3Netnum"  = 2

    "Mask23-Pub1Newbits" = 5
    "Mask23-Pub1Netnum"  = 3
    "Mask23-Pub2Newbits" = 5
    "Mask23-Pub2Netnum"  = 4
    "Mask23-Pub3Newbits" = 5
    "Mask23-Pub3Netnum"  = 5

    "Mask23-Pr11Newbits" = 5
    "Mask23-Pr11Netnum"  = 6
    "Mask23-Pr12Newbits" = 5
    "Mask23-Pr12Netnum"  = 7
    "Mask23-Pr13Newbits" = 5
    "Mask23-Pr13Netnum"  = 8

    "Mask23-Pr21Newbits" = 4
    "Mask23-Pr21Netnum"  = 7
    "Mask23-Pr22Newbits" = 4
    "Mask23-Pr22Netnum"  = 8
    "Mask23-Pr23Newbits" = 4
    "Mask23-Pr23Netnum"  = 9

    "Mask23-Int1Newbits" = 5
    "Mask23-Int1Netnum"  = 9
    "Mask23-Int2Newbits" = 5
    "Mask23-Int2Netnum"  = 10
    "Mask23-Int3Newbits" = 5
    "Mask23-Int3Netnum"  = 11

    # Map Network /23 Dos Zonas
    "Mask23v2-Nat1Newbits" = 5
    "Mask23v2-Nat1Netnum"  = 0
    "Mask23v2-Nat2Newbits" = 5
    "Mask23v2-Nat2Netnum"  = 1
    "Mask23v2-Nat3Newbits" = 5
    "Mask23v2-Nat3Netnum"  = 1

    "Mask23v2-Pub1Newbits" = 5
    "Mask23v2-Pub1Netnum"  = 2
    "Mask23v2-Pub2Newbits" = 5
    "Mask23v2-Pub2Netnum"  = 3
    "Mask23v2-Pub3Newbits" = 5
    "Mask23v2-Pub3Netnum"  = 3

    "Mask23v2-Pr11Newbits" = 4
    "Mask23v2-Pr11Netnum"  = 5
    "Mask23v2-Pr12Newbits" = 4
    "Mask23v2-Pr12Netnum"  = 6
    "Mask23v2-Pr13Newbits" = 4
    "Mask23v2-Pr13Netnum"  = 6

    "Mask23v2-Pr21Newbits" = 2
    "Mask23v2-Pr21Netnum"  = 2
    "Mask23v2-Pr22Newbits" = 2
    "Mask23v2-Pr22Netnum"  = 3
    "Mask23v2-Pr23Newbits" = 2
    "Mask23v2-Pr23Netnum"  = 3

    "Mask23v2-Int1Newbits" = 5
    "Mask23v2-Int1Netnum"  = 4
    "Mask23v2-Int2Newbits" = 5
    "Mask23v2-Int2Netnum"  = 5
    "Mask23v2-Int3Newbits" = 5
    "Mask23v2-Int3Netnum"  = 5

    # Map Network /24
    "Mask24-Nat1Newbits" = 7
    "Mask24-Nat1Netnum"  = 0
    "Mask24-Nat2Newbits" = 7
    "Mask24-Nat2Netnum"  = 1
    "Mask24-Nat3Newbits" = 7
    "Mask24-Nat3Netnum"  = 2

    "Mask24-Pub1Newbits" = 7
    "Mask24-Pub1Netnum"  = 3
    "Mask24-Pub2Newbits" = 7
    "Mask24-Pub2Netnum"  = 4
    "Mask24-Pub3Newbits" = 7
    "Mask24-Pub3Netnum"  = 5

    "Mask24-Pr11Newbits" = 7
    "Mask24-Pr11Netnum"  = 6
    "Mask24-Pr12Newbits" = 7
    "Mask24-Pr12Netnum"  = 7
    "Mask24-Pr13Newbits" = 7
    "Mask24-Pr13Netnum"  = 8

    "Mask24-Pr21Newbits" = 7
    "Mask24-Pr21Netnum"  = 9
    "Mask24-Pr22Newbits" = 7
    "Mask24-Pr22Netnum"  = 10
    "Mask24-Pr23Newbits" = 7
    "Mask24-Pr23Netnum"  = 11

    "Mask24-Int1Newbits" = 7
    "Mask24-Int1Netnum"  = 12
    "Mask24-Int2Newbits" = 7
    "Mask24-Int2Netnum"  = 13
    "Mask24-Int3Newbits" = 7
    "Mask24-Int3Netnum"  = 14

    # Map Network /22 Internal
    "Mask22-Int-Nat1Newbits" = 6
    "Mask22-Int-Nat1Netnum"  = 0
    "Mask22-Int-Nat2Newbits" = 6
    "Mask22-Int-Nat2Netnum"  = 1
    "Mask22-Int-Nat3Newbits" = 6
    "Mask22-Int-Nat3Netnum"  = 2

    "Mask22-Int-Pub1Newbits" = 6
    "Mask22-Int-Pub1Netnum"  = 3
    "Mask22-Int-Pub2Newbits" = 6
    "Mask22-Int-Pub2Netnum"  = 4
    "Mask22-Int-Pub3Newbits" = 6
    "Mask22-Int-Pub3Netnum"  = 5

    "Mask22-Int-Pr11Newbits" = 4
    "Mask22-Int-Pr11Netnum"  = 3
    "Mask22-Int-Pr12Newbits" = 4
    "Mask22-Int-Pr12Netnum"  = 4
    "Mask22-Int-Pr13Newbits" = 4
    "Mask22-Int-Pr13Netnum"  = 5

    "Mask22-Int-Pr21Newbits" = 3
    "Mask22-Int-Pr21Netnum"  = 3
    "Mask22-Int-Pr22Newbits" = 3
    "Mask22-Int-Pr22Netnum"  = 4
    "Mask22-Int-Pr23Newbits" = 3
    "Mask22-Int-Pr23Netnum"  = 5

    "Mask22-Int-Int1Newbits" = 6
    "Mask22-Int-Int1Netnum"  = 6
    "Mask22-Int-Int2Newbits" = 6
    "Mask22-Int-Int2Netnum"  = 7
    "Mask22-Int-Int3Newbits" = 6
    "Mask22-Int-Int3Netnum"  = 8
  }
}

