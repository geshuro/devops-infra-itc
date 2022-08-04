
resource "aws_nat_gateway" "nat-gw" {
  count         = var.nat-gw-count == 0 ? 0 : var.nat-gw-count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.bastion-nat-subnet[count.index].id
  tags          = merge(tomap({Name = "ngw-${var.vpcName}-${count.index}"}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }

}