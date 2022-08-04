resource "aws_network_acl" "public_bastion_nat_subnet" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.bastion-nat-subnet.*.id
  tags       = merge(map("Name", "acl-nat-${var.vpcName}"), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "aws_network_acl" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public-subnet.*.id
  tags       = merge(map("Name", "acl-pub-${var.vpcName}"), var.tags)
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }

}

resource "aws_network_acl" "private_internal_subnet" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private-internal-subnet.*.id
  tags       = merge(map("Name", "acl-int-${var.vpcName}"), var.tags)
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "aws_network_acl" "private_and_lb_subnet" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id, aws_subnet.private-lb-subnet[0].id, aws_subnet.private-lb-subnet[1].id]
  tags       = merge(map("Name", "acl-priv-${var.vpcName}"), var.tags)
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "aws_network_acl_rule" "public_bastion_nat_subnet_ingress" {
  network_acl_id = aws_network_acl.public_bastion_nat_subnet.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" # All Traffic
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" #TODO: ¿Restringir a un CIDR concreto?
  from_port      = 22
  to_port        = 22

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

# resource "aws_network_acl_rule" "public_bastion_nat_subnet_ingress2" {
#   count          = var.bastion_nat_subnet-count
#   network_acl_id = aws_network_acl.public_bastion_nat_subnet[count.index].id
#   rule_number    = 200
#   egress         = false
#   protocol       = "-1" #-1 means ALL. We need ephemeral ports
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 1024
#   to_port        = 65535

#   lifecycle {
#     prevent_destroy = false
#     #TODO: IgnoreChanges
#   }
# }

resource "aws_network_acl_rule" "public_bastion_nat_subnet_egress" {
  network_acl_id = aws_network_acl.public_bastion_nat_subnet.id
  rule_number    = 100
  egress         = true
  protocol       = "-1" # All Traffic de salida
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

# resource "aws_network_acl_rule" "public_bastion_nat_subnet_egress2" {
#   #count          = var.bastion_nat_subnet-count
#   network_acl_id = aws_network_acl.public_bastion_nat_subnet.id
#   rule_number    = 200
#   egress         = true
#   protocol       = "-1" #-1 means ALL. We need ephemeral ports
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 1024
#   to_port        = 65535

#   lifecycle {
#     prevent_destroy = false
#     #TODO: IgnoreChanges
#   }
# }

resource "aws_network_acl_rule" "public_subnet_ingress" {
  network_acl_id = aws_network_acl.public_subnet.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
resource "aws_network_acl_rule" "public_subnet_egress" {
  network_acl_id = aws_network_acl.public_subnet.id
  rule_number    = 100
  egress         = true
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "aws_network_acl_rule" "private_and_lb_subnets_ingress" {
  network_acl_id = aws_network_acl.private_and_lb_subnet.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
resource "aws_network_acl_rule" "private_and_lb_subnets_egress" {
  network_acl_id = aws_network_acl.private_and_lb_subnet.id
  rule_number    = 100
  egress         = true
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
resource "aws_network_acl_rule" "private_internal_subnet_ingress" {
  network_acl_id = aws_network_acl.private_internal_subnet.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}
resource "aws_network_acl_rule" "private_internal_subnet_egress" {
  network_acl_id = aws_network_acl.private_internal_subnet.id
  rule_number    = 100
  egress         = true
  protocol       = "-1" #-1 means ALL
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}