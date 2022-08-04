
resource "aws_vpc_peering_connection" "peering" {
  count             = (var.VPCPeeringEnable == "true" ? 1 : 0)
  #peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id       =  var.destinoVPCId
  vpc_id            = var.origenVPCId
  auto_accept       = true

  tags = {
    Name = var.DescriptionVPCPeering
  }
}
