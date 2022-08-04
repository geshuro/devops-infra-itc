/**
* ## Ejemplo
* Ejemplo de integraccion de modulo y funcionamiento.
* Se trata de cargar el modulo pasandoles las dos variables necesarias, y este proporciona lista de subnets segun el mapa de red que le indiquemos.
* Las dos variables a pasar son:
*   VPC-CIDR = cidr de la vpc Ej. "10.0.0.0/22"
*   planVPC = Seleccion de plan Ej. "Mask22" se puede seleccionar Mask22, Mask23, Mask24, Mask22-int
*
* ## Integraccion, tiene configurado la informacion en la salida, esta podemos utilizarla 
*
* **module.NOMBRE_DEL_MODULO.NOMBRE_RECURSO_OUTPUTS**
*
*  Ej. module.map_vpc.ListSubnetsInt
*
* ## Prueba de modulo, una vez hallamos configurado con nuestros valores el archivo var.tfvars
*
* **Comandos**
*
* terraform init
* terraform plan -var-file=var.tfvars
* terraform apply -var-file=var.tfvars
*
*/

module "map_vpc" {
  source   = "../../map_vpc"
  VPC-CIDR = var.VPC-CIDR
  planVPC  = var.planVPC
}


