
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

# route associations private (Route table shared between private & private LB subnets)
resource "aws_route_table_association" "private-subnets" {
  depends_on     = [aws_route_table.private-subnet]
  count          = var.private_subnet-count # this number depends on the number of NAT Gateways (More restrictive than private_subnet-count)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-subnet.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

# route associations private (Route table shared between private & private LB subnets)
resource "aws_route_table_association" "private-lb-subnets" {
  depends_on     = [aws_route_table.private-subnet]
  count          = var.private_lb_subnet-count # this number depends on the number of NAT Gateways (More restrictive than private_subnet-count)
  subnet_id      = aws_subnet.private-lb-subnet[count.index].id
  route_table_id = aws_route_table.private-subnet.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

# route associations private-internal-subnets
resource "aws_route_table_association" "internal-subnet" {
  depends_on     = [aws_route_table.private-internal-subnet]
  count          = var.private_internal_subnet-count # this number depends on the number of NAT Gateways (More restrictive than private_subnet-count)
  subnet_id      = aws_subnet.private-internal-subnet[count.index].id
  route_table_id = aws_route_table.private-internal-subnet.id
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
