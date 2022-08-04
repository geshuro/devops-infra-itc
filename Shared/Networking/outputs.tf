#########
#  VPC  #
#########
output "vpc_id" {
  value = module.networking.vpc_id
}
output "vpc_arn" {
  value = module.networking.vpc_arn
}
output "vpc_cidr_block" {
  value = module.networking.vpc_cidr_block
}
output "vpc_cidr_name" {
  value = module.networking.vpc_cidr_name
}

#################
# Subnet Public #
#################
output "public_subnet-id" {
  value = module.networking.public_subnet-id
}
output "public_subnet-cidrblock" {
  value = module.networking.public_subnet-cidrblock
}

#####################
# Subnet Private 1 #
#####################
output "private_1_subnet-id" {
  value = module.networking.private_lb_subnet-id
}
output "private_1_subnet-cidrblock" {
  value = module.networking.private_lb_subnet-cidrblock
}

#####################
#  Subnet Private 2  #
#####################
output "private_2_subnet-id" {
  value = module.networking.private_subnet-id
}
output "private_2_subnet-cidrblock" {
  value = module.networking.private_subnet-cidrblock
}

###########################
# Subnet Private Internal #
###########################
output "private-internal-subnet-id" {
  value = module.networking.private-internal-subnet-id
}
output "private-internal-subnet-cidrblock" {
  value = module.networking.private-internal-subnet-cidrblock
}

######################
# Subnet Nat #
######################
output "nat-subnet-id" {
  value = module.networking.bastion-nat-subnet-id
}
output "bastion-nat-subnet-cidrblock" {
  value = module.networking.bastion-nat-subnet-cidrblock
}

# ################
# #     EIPS     #
# ################
output "eip_nat-public_ip" {
  value = module.networking.eip_nat-public_ip
}

# ################
# #     IGW      #
# ################
output "internet_gateway-main_gw-id" {
  value = module.networking.internet_gateway-main_gw-id
}
output "internet_gateway-main_gw-name" {
  value = module.networking.internet_gateway-main_gw-name
}

# ################
# #    NAT GW    #
# ################
output "nat_gateway-nat_gw-id" {
  value = module.networking.nat_gateway-nat_gw-id
}
output "nat_gateway-nat_gw-name" {
  value = module.networking.nat_gateway-nat_gw-name
}
output "nat_gateway-nat_gw-public_ip" {
  value = module.networking.nat_gateway-nat_gw-public_ip
}
output "nat_gateway-nat_gw-subnet_id" {
  value = module.networking.nat_gateway-nat_gw-subnet_id
}
output "nat_gateway-nat_gw-subnet_count" {
  value = module.networking.nat_gateway-nat_gw-subnet_count
}

# ################
# # Route 53     #
# ################

output "internal_service_domain" {
  value = module.networking.internal_service_domain
}

output "internal_service_domain_id" {
  value = module.networking.internal_service_domain_id
}


# ################
# # VPC Route    #
# ################
output "route_table-private_internal_subnet-ids" {
  value = module.networking.route_table-private_internal_subnet-ids
}
output "route_table-private_internal_subnet-name" {
  value = module.networking.route_table-private_internal_subnet-name
}
output "route_table-public_subnet-ids" {
  value = module.networking.route_table-public_subnet-ids
}
output "route_table-public_bastion_subnet-ids" {
  value = module.networking.route_table-public_bastion_subnet-ids
}
output "route_table-private_subnet-ids-za" {
  value = module.networking.route_table-private_subnet-ids-za
}
/* imendoza output "route_table-private_subnet-ids-zb" {
  value = module.networking.route_table-private_subnet-ids-zb
}*/