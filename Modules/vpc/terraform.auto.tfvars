## Global Main VPC Address_Space
address_space = "10.150.0.0/22"

# Main & Global variables
vpcName                       = "management-vpc"
AWS_REGION                    = "eu-west-1"
public_subnet-count           = 3
bastion_nat_subnet-count      = 3
private_subnet-count          = 3
private_lb_subnet-count       = 3
private_internal_subnet-count = 3
nat-gw-count                  = 3 # Numero de NAT Gateways a crear
route-table-count             = 3

# Subnets CIDR 
cidr_block_public_subnet           = ["10.150.0.0/27", "10.150.0.32/27", "10.150.0.64/27"]
cidr_block_bastion_nat_subnet      = ["10.150.0.96/27", "10.150.0.128/27", "10.150.0.160/27"]
cidr_block_private-subnet          = ["10.150.0.192/27", "10.150.0.224/27", "10.150.1.0/27"]
cidr_block_private-lb-subnet       = ["10.150.1.32/27", "10.150.1.64/27", "10.150.1.96/27"]
cidr_block_private-internal-subnet = ["10.150.1.128/27", "10.150.1.160/27", "10.150.1.192/27"]

#VPC_Endpoints
create_vpc                             = true
enable_s3_endpoint                     = false
enable_codecommit_endpoint             = false
enable_dynamodb_endpoint               = false
enable_codebuild_endpoint              = false
enable_git_codecommit_endpoint         = false
enable_config_endpoint                 = false
codebuild_endpoint_private_dns_enabled = false
codebuild_endpoint_security_group_ids  = ["sg-090bd5b960962a2ab"] # Temporarily hardcode with DefaultVPC SecurityGroup
