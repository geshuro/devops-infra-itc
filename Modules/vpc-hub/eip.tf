resource "aws_eip" "nat" {
  vpc   = true
  count = var.nat-gw-count   
  tags  = merge(tomap({Name = "eip-${var.vpcName}-nat-${count.index}"}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}