## Ejemplo

Ejemplo de integraccion de modulo y funcionamiento.  
Se trata de cargar el modulo pasandoles las dos variables necesarias, y este proporciona lista de subnets segun el mapa de red que le indiquemos.  
Las dos variables a pasar son:
  VPC-CIDR = cidr de la vpc Ej. "10.0.0.0/22"
  planVPC = Seleccion de plan Ej. "Mask22" se puede seleccionar Mask22, Mask23, Mask24, Mask22-int

## Integracion, tiene configurado la informacion en la salida, esta podemos utilizarla

**module.NOMBRE\_DEL\_MODULO.NOMBRE\_RECURSO\_OUTPUTS**

 Ej. module.map\_vpc.ListSubnetsInt

## Prueba de modulo, una vez hallamos configurado con nuestros valores el archivo variables.tfvars

**Comandos**

terraform init  
terraform plan -var-file=variables.tfvars  
terraform apply -var-file=variables.tfvars

## Providers

No provider.

## Inputs

| Name     | Description                                                                                                                                                                    | Type  | Default | Required |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----- | ------- |:--------:|
| VPC-CIDR | Cidr asignado al VPC y del que partimos para generar las subnets                                                                                                               | `any` | n/a     | yes      |
| planVPC  | Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan default. Atiende al nombre de cabecera dado a los mapas de red | `any` | Mask22  | yes      |

## Outputs

| Name           | Description                                                                                   |
| -------------- | --------------------------------------------------------------------------------------------- |
| ListSubnetsInt | Salida de las subnets Internal en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28            |
| ListSubnetsNat | Salida de las subnets de Nat en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28              |
| ListSubnetsPr1 | Salida de las subnets Privadas Nivel1 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28     |
| ListSubnetsPr2 | Salida de las subnets Privadas Nivel 2 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28    |
| ListSubnetsPub | Salida de las subnets Publicas en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28            |
| MaskVPC        | Mapa actualmente seleccionado dentro de la lista (Mask21, Mask22, Mask23, Mask24, Mask22-Int) |
