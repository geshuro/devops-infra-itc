module "map_vpc" {
  source   = "../../Modules/map_vpc"
  VPC-CIDR = var.vpcCIRD
  planVPC  = var.Maskplan
}

module "networking" {
  source                             = "../../Modules/vpc"
  cidr_block_bastion_nat_subnet      = ["${module.map_vpc.ListSubnetsNat1}", "${module.map_vpc.ListSubnetsNat2}"]
  cidr_block_public_subnet           = ["${module.map_vpc.ListSubnetsPub1}", "${module.map_vpc.ListSubnetsPub2}"]
  cidr_block_private-lb-subnet       = ["${module.map_vpc.ListSubnetsPr11}", "${module.map_vpc.ListSubnetsPr12}"]
  cidr_block_private-subnet          = ["${module.map_vpc.ListSubnetsPr21}", "${module.map_vpc.ListSubnetsPr22}"]
  cidr_block_private-internal-subnet = ["${module.map_vpc.ListSubnetsInt1}", "${module.map_vpc.ListSubnetsInt2}"]

  vpcName                       = var.vpcName
  public_subnet-count           = 2
  bastion_nat_subnet-count      = 0
  private_subnet-count          = 2
  private_lb_subnet-count       = 2
  private_internal_subnet-count = 2
  nat-gw-count                  = 0
  route-table-count             = 2

  address_space = var.vpcCIRD

  #Route53
  CreateRoute53 = var.CreateRoute53
  InternalZoneId = var.InternalZoneId
  Route53name    = var.DNSInternalName

  tags = {
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

#Se configura el peering con shared y se añade las rutas necesarias.
module "peering" {
  source                = "../../Modules/vpc-peering"
  VPCPeeringEnable      = var.VPCPeeringEnableShared
  destinoVPCId          = var.destinoVPCIdShared
  origenVPCId           = module.networking.vpc_id
  DescriptionVPCPeering = var.DescriptionVPCPeeringShared
}

resource "aws_route" "route-peering-nat" {
  route_table_id            = module.networking.route_table-public_bastion_subnet-ids[0]
  destination_cidr_block    = var.vpcCIRDShared
  vpc_peering_connection_id = module.peering.id
}

resource "aws_route" "route-peering-pub" {
  route_table_id            = module.networking.route_table-public_subnet-ids[0]
  destination_cidr_block    = var.vpcCIRDShared
  vpc_peering_connection_id = module.peering.id
}

resource "aws_route" "route-peering-pri" {
  route_table_id            = module.networking.route_table-private_subnet-ids[0]
  destination_cidr_block    = var.vpcCIRDShared
  vpc_peering_connection_id = module.peering.id
}

resource "aws_route" "route-peering-int" {
  route_table_id            = module.networking.route_table-private_internal_subnet-ids[0]
  destination_cidr_block    = var.vpcCIRDShared
  vpc_peering_connection_id = module.peering.id
}