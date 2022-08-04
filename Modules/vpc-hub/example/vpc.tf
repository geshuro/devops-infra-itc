module "networking" {
  source                             = "../Modules/networking"
  cidr_block_public_subnet           = ["10.150.0.0/27", "10.150.0.32/27", "10.150.0.64/27"]
  cidr_block_bastion_nat_subnet      = ["10.150.0.96/27", "10.150.0.128/27", "10.150.0.160/27"]
  cidr_block_private-subnet          = ["10.150.0.192/27", "10.150.0.224/27", "10.150.1.0/27"]
  cidr_block_private-lb-subnet       = ["10.150.1.32/27", "10.150.1.64/27", "10.150.1.96/27"]
  cidr_block_private-internal-subnet = ["10.150.1.128/27", "10.150.1.160/27", "10.150.1.192/27"]


  vpcName                       = "management-vpc"
  public_subnet-count           = 3
  bastion_nat_subnet-count      = 3
  private_subnet-count          = 3
  private_lb_subnet-count       = 3
  private_internal_subnet-count = 3
  nat-gw-count                  = 3
  route-table-count             = 3

  address_space = "10.150.0.0/22"

  #Route53
  Route53name = "internal.domain.example"
  main_vpc    = "vpc-12345678"

  tags = {
    Environment = "pro"
    CostCenter  = ""
    ServiceId   = ""
    ProjectId   = ""
  }
}