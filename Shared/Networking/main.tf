module "map_vpc" {
  source   = "../../Modules/map_vpc"
  VPC-CIDR = var.vpcCIRD
  planVPC  = var.Maskplan
}

module "networking" {
  source                             = "../../Modules/vpc-hub"
  cidr_block_bastion_nat_subnet      = ["${module.map_vpc.ListSubnetsNat1}", "${module.map_vpc.ListSubnetsNat2}"]
  cidr_block_public_subnet           = ["${module.map_vpc.ListSubnetsPub1}", "${module.map_vpc.ListSubnetsPub2}"]
  cidr_block_private-lb-subnet       = ["${module.map_vpc.ListSubnetsPr11}", "${module.map_vpc.ListSubnetsPr12}"]
  cidr_block_private-subnet          = ["${module.map_vpc.ListSubnetsPr21}", "${module.map_vpc.ListSubnetsPr22}"]
  cidr_block_private-internal-subnet = ["${module.map_vpc.ListSubnetsInt1}", "${module.map_vpc.ListSubnetsInt2}"]

  vpcName                       = var.vpcName
  public_subnet-count           = 1
  bastion_nat_subnet-count      = 1
  private_subnet-count          = 1
  private_lb_subnet-count       = 0
  private_internal_subnet-count = 0
  nat-gw-count                  = 1
  route-table-count             = 1

  address_space = var.vpcCIRD

  #Route53
  CreateRoute53 = var.CreateRoute53
  Route53name   = var.DNSInternalName

  tags = {
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

module "VPCEndpoints" {
  source                   = "../../Modules/VPCEndpoints"
  main_vpc                 = module.networking.vpc_id
  subnets-id               = module.networking.private_subnet-id
  route-table-private-za      = module.networking.route_table-private_subnet-ids-za
  //route-table-private-zb      = module.networking.route_table-private_subnet-ids-zb
  nat-gw-count             = module.networking.nat_gateway-nat_gw-subnet_count
  create_vpc               = true
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = false
}