
# resource "aws_nat_gateway" "nat-gw" {
#   count         = var.nat-gw-count == 0 ? 0 : 1
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.bastion-nat-subnet[0].id
#   tags          = merge(map("Name", "ngw-${var.vpcName}-${count.index}"), var.tags)

#   lifecycle {
#     prevent_destroy = false
#     #TODO: IgnoreChanges
#   }

# }
