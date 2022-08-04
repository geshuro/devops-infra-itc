output "id" {
  description = "Identificador Id VPC peering"
  #value       = "${var.VPCPeeringEnable == "true" ? aws_vpc_peering_connection.peering[*].id : ""}"
  value         = "${var.VPCPeeringEnable == "true" ? aws_vpc_peering_connection.peering[0].id : "no_id"}"
}

output "status" {
  description = "Status VPC Peering"
  #value       = "${var.VPCPeeringEnable == "true" ? aws_vpc_peering_connection.peering[0].accept_status : ""}"
  value         = "${var.VPCPeeringEnable == "true" ? aws_vpc_peering_connection.peering[0].accept_status : "no_status"}"
}