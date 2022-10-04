# route tables public subnets
resource "aws_route_table" "public-subnet" {
  vpc_id = aws_vpc.main.id
  #count  = var.public_subnet-count
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = merge(tomap({Name = "rt-${var.vpcName}-pub"}), var.tags)
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        route, tags
    ]
    #TODO: IgnoreChanges
  }
}

# route tables public bastion subnets
resource "aws_route_table" "public-bastion-subnet" {
  vpc_id = aws_vpc.main.id
  #count  = var.bastion_nat_subnet-count
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags =  merge(tomap({Name = "rt-${var.vpcName}-nat"}), var.tags)
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        route, tags
    ]
    #TODO: IgnoreChanges
  }
}

# Private Subnets
# With a NAT GW attached (but share route table with Private LB Subnets)
resource "aws_route_table" "private-subnet" {
  #depends_on = [aws_nat_gateway.nat-gw]
  vpc_id     = aws_vpc.main.id
  #count      = var.nat-gw-count # reuse nat-gw-count variable because of dependency between nat_gateway & route_table  
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat-gw[0].id
  # }
  tags = merge(tomap({Name = "rt-${var.vpcName}-pri"}), var.tags)
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        route, tags
    ]
    #TODO: IgnoreChanges
  }
}

#Internal subnet ==> Without any NAT GW attached
resource "aws_route_table" "private-internal-subnet" {
  vpc_id = aws_vpc.main.id
  #count  = var.private_internal_subnet-count # reuse nat-gw-count variable because of dependency between nat_gateway & route_table  

  tags = merge(tomap({Name = "rt-${var.vpcName}-int"}), var.tags)
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        route, tags
    ]
    #TODO: IgnoreChanges
  }
}
