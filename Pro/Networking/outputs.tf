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
# #     IGW      #
# ################
output "internet_gateway-main_gw-id" {
  value = module.networking.internet_gateway-main_gw-id
}
output "internet_gateway-main_gw-name" {
  value = module.networking.internet_gateway-main_gw-name
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

# ######################
# # VPC Peering Shared #
# ######################

output "vpc_peering_shared_id" {
  description = "Identificador Id VPC peering shared"
  value       = module.peering.id
}

output "vpc_peering_shared_status" {
  description = "Status VPC Peering shared"
  value       = module.peering.status
}