## Descripcion Modulo  
Con este modulo lo que pretendemos es crear un mapa de redes que nos devuelva, por capas una cadena con las subnets configuradas.  
Este modulo se ha contruido para resolver mapas de redes, de forma agnostica a la cloud en la que pueda trabajar.  
Cuando se recojan los datos, estos deberan ser tratados para poder utilizarse por cada proveedor cloud.

## Configurando los provider

**Provider use null**

Lo utilizamos para generar recursos sin aplicacion de estado.

## Recursos

**data "null\_data\_source" "subnets"**

## Providers

| Name | Version |
|------|---------|
| null | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| VPC-CIDR | Cidr asignado al VPC y del que partimos para generar las subnets | `any` | n/a | yes |
| map\_subneting | Configuracion de los mapas segun su funcion. Utilizamos la funcion cidrsubnet (newbits(Indica el numero en el array, de los modelos de subnet que existen dentro del CIDR dado), netnum(Nos indica el numero dentro del array de extraer todas las subnet indicadas en el newbits)) | `map` | <pre>{<br>  "Mask21-Int1Netnum": 1,<br>  "Mask21-Int1Newbits": 5,<br>  "Mask21-Int2Netnum": 2,<br>  "Mask21-Int2Newbits": 5,<br>  "Mask21-Int3Netnum": 3,<br>  "Mask21-Int3Newbits": 5,<br>  "Mask21-Nat1Netnum": 0,<br>  "Mask21-Nat1Newbits": 7,<br>  "Mask21-Nat2Netnum": 1,<br>  "Mask21-Nat2Newbits": 7,<br>  "Mask21-Nat3Netnum": 2,<br>  "Mask21-Nat3Newbits": 7,<br>  "Mask21-Pr11Netnum": 5,<br>  "Mask21-Pr11Newbits": 4,<br>  "Mask21-Pr12Netnum": 6,<br>  "Mask21-Pr12Newbits": 4,<br>  "Mask21-Pr13Netnum": 7,<br>  "Mask21-Pr13Newbits": 4,<br>  "Mask21-Pr21Netnum": 4,<br>  "Mask21-Pr21Newbits": 3,<br>  "Mask21-Pr22Netnum": 5,<br>  "Mask21-Pr22Newbits": 3,<br>  "Mask21-Pr23Netnum": 6,<br>  "Mask21-Pr23Newbits": 3,<br>  "Mask21-Pub1Netnum": 2,<br>  "Mask21-Pub1Newbits": 4,<br>  "Mask21-Pub2Netnum": 3,<br>  "Mask21-Pub2Newbits": 4,<br>  "Mask21-Pub3Netnum": 4,<br>  "Mask21-Pub3Newbits": 4,<br>  "Mask22-Int-Int1Netnum": 6,<br>  "Mask22-Int-Int1Newbits": 6,<br>  "Mask22-Int-Int2Netnum": 7,<br>  "Mask22-Int-Int2Newbits": 6,<br>  "Mask22-Int-Int3Netnum": 8,<br>  "Mask22-Int-Int3Newbits": 6,<br>  "Mask22-Int-Nat1Netnum": 0,<br>  "Mask22-Int-Nat1Newbits": 6,<br>  "Mask22-Int-Nat2Netnum": 1,<br>  "Mask22-Int-Nat2Newbits": 6,<br>  "Mask22-Int-Nat3Netnum": 2,<br>  "Mask22-Int-Nat3Newbits": 6,<br>  "Mask22-Int-Pr11Netnum": 3,<br>  "Mask22-Int-Pr11Newbits": 4,<br>  "Mask22-Int-Pr12Netnum": 4,<br>  "Mask22-Int-Pr12Newbits": 4,<br>  "Mask22-Int-Pr13Netnum": 5,<br>  "Mask22-Int-Pr13Newbits": 4,<br>  "Mask22-Int-Pr21Netnum": 3,<br>  "Mask22-Int-Pr21Newbits": 3,<br>  "Mask22-Int-Pr22Netnum": 4,<br>  "Mask22-Int-Pr22Newbits": 3,<br>  "Mask22-Int-Pr23Netnum": 5,<br>  "Mask22-Int-Pr23Newbits": 3,<br>  "Mask22-Int-Pub1Netnum": 3,<br>  "Mask22-Int-Pub1Newbits": 6,<br>  "Mask22-Int-Pub2Netnum": 4,<br>  "Mask22-Int-Pub2Newbits": 6,<br>  "Mask22-Int-Pub3Netnum": 5,<br>  "Mask22-Int-Pub3Newbits": 6,<br>  "Mask22-Int1Netnum": 3,<br>  "Mask22-Int1Newbits": 6,<br>  "Mask22-Int2Netnum": 4,<br>  "Mask22-Int2Newbits": 6,<br>  "Mask22-Int3Netnum": 5,<br>  "Mask22-Int3Newbits": 6,<br>  "Mask22-Nat1Netnum": 0,<br>  "Mask22-Nat1Newbits": 6,<br>  "Mask22-Nat2Netnum": 1,<br>  "Mask22-Nat2Newbits": 6,<br>  "Mask22-Nat3Netnum": 2,<br>  "Mask22-Nat3Newbits": 6,<br>  "Mask22-Pr11Netnum": 4,<br>  "Mask22-Pr11Newbits": 5,<br>  "Mask22-Pr12Netnum": 5,<br>  "Mask22-Pr12Newbits": 5,<br>  "Mask22-Pr13Netnum": 6,<br>  "Mask22-Pr13Newbits": 5,<br>  "Mask22-Pr21Netnum": 7,<br>  "Mask22-Pr21Newbits": 4,<br>  "Mask22-Pr22Netnum": 8,<br>  "Mask22-Pr22Newbits": 4,<br>  "Mask22-Pr23Netnum": 9,<br>  "Mask22-Pr23Newbits": 4,<br>  "Mask22-Pub1Netnum": 4,<br>  "Mask22-Pub1Newbits": 4,<br>  "Mask22-Pub2Netnum": 6,<br>  "Mask22-Pub2Newbits": 4,<br>  "Mask22-Pub3Netnum": 7,<br>  "Mask22-Pub3Newbits": 4,<br>  "Mask23-Int1Netnum": 9,<br>  "Mask23-Int1Newbits": 5,<br>  "Mask23-Int2Netnum": 10,<br>  "Mask23-Int2Newbits": 5,<br>  "Mask23-Int3Netnum": 11,<br>  "Mask23-Int3Newbits": 5,<br>  "Mask23-Nat1Netnum": 0,<br>  "Mask23-Nat1Newbits": 5,<br>  "Mask23-Nat2Netnum": 1,<br>  "Mask23-Nat2Newbits": 5,<br>  "Mask23-Nat3Netnum": 2,<br>  "Mask23-Nat3Newbits": 5,<br>  "Mask23-Pr11Netnum": 6,<br>  "Mask23-Pr11Newbits": 5,<br>  "Mask23-Pr12Netnum": 7,<br>  "Mask23-Pr12Newbits": 5,<br>  "Mask23-Pr13Netnum": 8,<br>  "Mask23-Pr13Newbits": 5,<br>  "Mask23-Pr21Netnum": 7,<br>  "Mask23-Pr21Newbits": 4,<br>  "Mask23-Pr22Netnum": 8,<br>  "Mask23-Pr22Newbits": 4,<br>  "Mask23-Pr23Netnum": 9,<br>  "Mask23-Pr23Newbits": 4,<br>  "Mask23-Pub1Netnum": 3,<br>  "Mask23-Pub1Newbits": 5,<br>  "Mask23-Pub2Netnum": 4,<br>  "Mask23-Pub2Newbits": 5,<br>  "Mask23-Pub3Netnum": 5,<br>  "Mask23-Pub3Newbits": 5,<br>  "Mask24-Int1Netnum": 12,<br>  "Mask24-Int1Newbits": 7,<br>  "Mask24-Int2Netnum": 13,<br>  "Mask24-Int2Newbits": 7,<br>  "Mask24-Int3Netnum": 14,<br>  "Mask24-Int3Newbits": 7,<br>  "Mask24-Nat1Netnum": 0,<br>  "Mask24-Nat1Newbits": 7,<br>  "Mask24-Nat2Netnum": 1,<br>  "Mask24-Nat2Newbits": 7,<br>  "Mask24-Nat3Netnum": 2,<br>  "Mask24-Nat3Newbits": 7,<br>  "Mask24-Pr11Netnum": 6,<br>  "Mask24-Pr11Newbits": 7,<br>  "Mask24-Pr12Netnum": 7,<br>  "Mask24-Pr12Newbits": 7,<br>  "Mask24-Pr13Netnum": 8,<br>  "Mask24-Pr13Newbits": 7,<br>  "Mask24-Pr21Netnum": 9,<br>  "Mask24-Pr21Newbits": 7,<br>  "Mask24-Pr22Netnum": 10,<br>  "Mask24-Pr22Newbits": 7,<br>  "Mask24-Pr23Netnum": 11,<br>  "Mask24-Pr23Newbits": 7,<br>  "Mask24-Pub1Netnum": 3,<br>  "Mask24-Pub1Newbits": 7,<br>  "Mask24-Pub2Netnum": 4,<br>  "Mask24-Pub2Newbits": 7,<br>  "Mask24-Pub3Netnum": 5,<br>  "Mask24-Pub3Newbits": 7<br>}</pre> | no |
| planVPC | Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan default. Atiende al nombre de cabecera dado a los mapas de red | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ListSubnetsInt | Salida de las subnets Internal en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28 |
| ListSubnetsNat | Salida de las subnets de Nat en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28 |
| ListSubnetsPr1 | Salida de las subnets Privadas Nivel1 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28 |
| ListSubnetsPr2 | Salida de las subnets Privadas Nivel 2 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28 |
| ListSubnetsPub | Salida de las subnets Publicas en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28 |
| MaskVPC | Mapa actualmente seleccionado dentro de la lista (Mask21, Mask22, Mask23, Mask24, Mask22-Int) |

