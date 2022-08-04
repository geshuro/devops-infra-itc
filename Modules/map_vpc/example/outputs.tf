# output "ListSubnetsNat" {
#   description = "Salida de las subnets de Nat en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28"
#   value       = "${module.map_vpc.ListSubnetsNat}"
# }
output "ListSubnetsPub" {
  description = "Salida de las subnets Publicas en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28"
  value       = "${module.map_vpc.ListSubnetsPub}"
}
output "ListSubnetsPr1" {
  description = "Salida de las subnets Privadas Nivel1 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28"
  value       = "${module.map_vpc.ListSubnetsPr1}"
}
output "ListSubnetsPr2" {
  description = "Salida de las subnets Privadas Nivel 2 en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28"
  value       = "${module.map_vpc.ListSubnetsPr2}"
}
output "ListSubnetsInt" {
  description = "Salida de las subnets Internal en formato: 10.3.0.0/28, 10.3.0.16/28, 10.3.0.32/28"
  value       = "${module.map_vpc.ListSubnetsInt}"
}
output "MaskVPC" {
  description = "Mapa actualmente seleccionado dentro de la lista (Mask21, Mask22, Mask23, Mask24, Mask22-Int)"
  value       = "${var.planVPC != "" ? var.planVPC : "Mask22"}"
}
