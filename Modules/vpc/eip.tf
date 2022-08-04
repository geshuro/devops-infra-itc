# resource "aws_eip" "nat" {
#   vpc   = true
#   #count = var.nat-gw-count # reuse nat-gw-count variable because of dependency between nat_gateway & route_table    
#   tags  = merge(map("Name", "eip-${var.vpcName}"), var.tags)

#   lifecycle {
#     prevent_destroy = false
#     #TODO: IgnoreChanges
#   }
# }
