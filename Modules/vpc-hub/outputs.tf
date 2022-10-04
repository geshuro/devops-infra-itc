#########
#  VPC  #
#########
output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_arn" {
  value = aws_vpc.main.arn
}
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}
output "vpc_cidr_name" {
  value = aws_vpc.main.tags["Name"]
}

#################
# Subnet Public #
#################
output "public_subnet-id" {
  value = aws_subnet.public-subnet.*.id
}
output "public_subnet-tags" {
  value = aws_subnet.public-subnet.*.tags
}
output "public_subnet-cidrblock" {
  value = aws_subnet.public-subnet.*.cidr_block
}
output "public_subnet-arn" {
  value = aws_subnet.public-subnet.*.arn
}

#####################
#  Subnet Private   #
#####################
output "private_subnet-id" {
  value = aws_subnet.private-subnet.*.id
}
output "private_subnet-tags" {
  value = aws_subnet.private-subnet.*.tags
}
output "private_subnet-cidrblock" {
  value = aws_subnet.private-subnet.*.cidr_block
}
output "private_subnet-arn" {
  value = aws_subnet.private-subnet.*.arn
}

#####################
# Subnet Private-lb #
#####################
output "private_lb_subnet-id" {
  value = aws_subnet.private-lb-subnet.*.id
}
output "private_lb_subnet_tags" {
  value = aws_subnet.private-lb-subnet.*.tags
}
output "private_lb_subnet-cidrblock" {
  value = aws_subnet.private-lb-subnet.*.cidr_block
}
output "private_lb_subnet-arn" {
  value = aws_subnet.private-lb-subnet.*.arn
}

###########################
# Subnet Private Internal #
###########################
output "private-internal-subnet-id" {
  value = aws_subnet.private-internal-subnet.*.id
}
output "private-internal-subnet_tags-Name" {
  value = aws_subnet.private-internal-subnet.*.tags
}
output "private-internal-subnet-cidrblock" {
  value = aws_subnet.private-internal-subnet.*.cidr_block
}
output "private-internal-subnet-arn" {
  value = aws_subnet.private-internal-subnet.*.arn
}

######################
# Subnet Bastion Nat #
######################
output "bastion-nat-subnet-id" {
  value = aws_subnet.bastion-nat-subnet.*.id
}
output "bastion-nat-subnet_tags-Name" {
  value = aws_subnet.bastion-nat-subnet.*.tags
}
output "bastion-nat-subnet-cidrblock" {
  value = aws_subnet.bastion-nat-subnet.*.cidr_block
}
output "bastion-nat-subnet-arn" {
  value = aws_subnet.bastion-nat-subnet.*.arn
}

# ################
# #     EIPS     #
# ################
output "eip_nat-public_ip" {
  value = aws_eip.nat.*.public_ip
}

# ################
# #     IGW      #
# ################
output "internet_gateway-main_gw-id" {
  value = aws_internet_gateway.main-gw.id
}
output "internet_gateway-main_gw-name" {
  value = aws_internet_gateway.main-gw.tags["Name"]
}

# ################
# #    NAT GW    #
# ################
output "nat_gateway-nat_gw-id" {
  value = aws_nat_gateway.nat-gw.*.id
}
output "nat_gateway-nat_gw-name" {
  value = aws_nat_gateway.nat-gw.*.tags
}
output "nat_gateway-nat_gw-public_ip" {
  value = aws_nat_gateway.nat-gw.*.public_ip
}
output "nat_gateway-nat_gw-subnet_id" {
  value = aws_nat_gateway.nat-gw.*.subnet_id
}
output "nat_gateway-nat_gw-subnet_count" {
  value = length(aws_nat_gateway.nat-gw)
}

# ################
# # ROUTE TABLES #
# ################
output "route_table-private_internal_subnet-ids" {
  value = aws_route_table.private-internal-subnet.*.id
}
output "route_table-private_internal_subnet-name" {
  value = aws_route_table.private-internal-subnet.*.tags
}
output "route_table-public_subnet-ids" {
  value = aws_route_table.public-subnet.*.id
}
output "route_table-public_bastion_subnet-ids" {
  value = aws_route_table.public-bastion-subnet.*.id
}
output "route_table-private_subnet-ids-za" {
  value = aws_route_table.private-subnet-za.*.id
}
output "route_table-private_subnet-ids-zb" {
  value = aws_route_table.private-subnet-zb.*.id
}
# ################
# # Route 53     #
# ################

output "internal_service_domain" {
  value = "${var.Route53name != "" ? var.Route53name : "NO-INSTALL"}"
}

output "internal_service_domain_id" {
  value = aws_route53_zone.main[*].zone_id
}