
# route associations main public subnets
resource "aws_route_table_association" "public-subnet" {
  depends_on     = [aws_route_table.public-subnet]
  count          = var.public_subnet-count # this number depends on the number of NAT Gateways
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-subnet.id

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

# route associations bastion public subnets
resource "aws_route_table_association" "bastion-public" {
  depends_on     = [aws_route_table.public-bastion-subnet]
  count          = var.bastion_nat_subnet-count # this number depends on the number of NAT Gateways
  subnet_id      = aws_subnet.bastion-nat-subnet[count.index].id
  route_table_id = aws_route_table.public-bastion-subnet.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "null_resource" "depends_on" {
  triggers = {
    depends_on = "${join("", var.depends)}"
  }
}

data "aws_subnet_ids" "subnets-lb-pri-zone-a" {
  depends_on = [aws_subnet.private-lb-subnet, aws_subnet.private-subnet]
  vpc_id = aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = ["sn-${var.vpcName}-${random_string.random.result}-pri-n1-za", "sn-${var.vpcName}-${random_string.random.result}-pri-n2-za"] # insert values here
  }
}
/* imendoza
data "aws_subnet_ids" "subnets-lb-pri-zone-b" {
  depends_on = [aws_subnet.private-lb-subnet, aws_subnet.private-subnet]
  vpc_id = aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = ["sn-${var.vpcName}-${random_string.random.result}-pri-n1-zb", "sn-${var.vpcName}-${random_string.random.result}-pri-n2-zb"] # insert values here
  }
}
*/
# route associations private (Route table shared between private & private LB subnets)
resource "aws_route_table_association" "private-lb-subnets-za" {
  depends_on     = [aws_route_table.private-subnet-za]
  count          = 2
  subnet_id      = element(tolist(data.aws_subnet_ids.subnets-lb-pri-zone-a.ids), count.index)
  route_table_id = aws_route_table.private-subnet-za.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
/* imendoza
# route associations private (Route table shared between private & private LB subnets)
resource "aws_route_table_association" "private-lb-subnets-zb" {
  depends_on     = [aws_route_table.private-subnet-zb]
  count          = 2
  subnet_id      = element(tolist(data.aws_subnet_ids.subnets-lb-pri-zone-b.ids), count.index)
  route_table_id = aws_route_table.private-subnet-zb.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}*/

/* imendoza # route associations private-internal-subnets
resource "aws_route_table_association" "internal-subnet" {
  depends_on     = [aws_route_table.private-internal-subnet]
  count          = var.nat-gw-count
  subnet_id      = aws_subnet.private-internal-subnet[count.index].id
  route_table_id = aws_route_table.private-internal-subnet.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}*/