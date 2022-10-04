# Datos cuenta AWS
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

# Sacar todos los datos de un workspace distinto.
data "terraform_remote_state" "shared-networking" {
  backend = "s3"
  config = {
    profile        = var.AWSprofileBackend
    bucket         = var.s3backend
    key            = var.sharedkeybackend
    region         = var.regionbackend 
    encrypt        = true
    dynamodb_table = var.DynamoDBbackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "terraform_remote_state" "dev-networking" {
  backend = "s3"
  config = {
    profile        = var.AWSprofileBackend
    bucket         = var.s3backend
    key            = var.devkeybackend
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.DynamoDBbackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "terraform_remote_state" "release-networking" {
  backend = "s3"
  config = {
    profile        = var.AWSprofileBackend 
    bucket         = var.s3backend
    key            = var.releasekeybackend
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.DynamoDBbackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

# Añadir tablas de ruta para alcanzar los vpc por peering desde shared

# shared to dev for nat
resource "aws_route" "route-peering-nat-shared-dev" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-public_bastion_subnet-ids[0]
  #element(tolist(data.aws_subnet_ids.subnets-lb-pri-zone-b.ids), count.index)
  destination_cidr_block    = data.terraform_remote_state.dev-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.dev-networking.outputs.vpc_peering_shared_id
}
# shared to release for nat
resource "aws_route" "route-peering-nat-shared-release" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-public_bastion_subnet-ids[0]
  destination_cidr_block    = data.terraform_remote_state.release-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.release-networking.outputs.vpc_peering_shared_id
}

# shared to dev for pub
resource "aws_route" "route-peering-pub-shared-dev" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-public_subnet-ids[0]
  destination_cidr_block    = data.terraform_remote_state.dev-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.dev-networking.outputs.vpc_peering_shared_id
}
# shared to release for pub
resource "aws_route" "route-peering-pub-shared-release" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-public_subnet-ids[0]
  destination_cidr_block    = data.terraform_remote_state.release-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.release-networking.outputs.vpc_peering_shared_id
}
# shared to dev for int
resource "aws_route" "route-peering-int-shared-dev" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_internal_subnet-ids[0]
  destination_cidr_block    = data.terraform_remote_state.dev-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.dev-networking.outputs.vpc_peering_shared_id
}
# shared to release for int
resource "aws_route" "route-peering-int-shared-release" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_internal_subnet-ids[0]
  destination_cidr_block    = data.terraform_remote_state.release-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.release-networking.outputs.vpc_peering_shared_id
}

resource "aws_route" "route-peering-pri-za-shared-dev" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_subnet-ids-za[0]
  destination_cidr_block    = data.terraform_remote_state.dev-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.dev-networking.outputs.vpc_peering_shared_id
}

resource "aws_route" "route-peering-pri-za-shared-release" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_subnet-ids-za[0]
  destination_cidr_block    = data.terraform_remote_state.release-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.release-networking.outputs.vpc_peering_shared_id
}

resource "aws_route" "route-peering-pri-zb-shared-dev" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_subnet-ids-zb[0]
  destination_cidr_block    = data.terraform_remote_state.dev-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.dev-networking.outputs.vpc_peering_shared_id
}

resource "aws_route" "route-peering-pri-zb-shared-release" {
  route_table_id            = data.terraform_remote_state.shared-networking.outputs.route_table-private_subnet-ids-zb[0]
  destination_cidr_block    = data.terraform_remote_state.release-networking.outputs.vpc_cidr_block
  vpc_peering_connection_id = data.terraform_remote_state.release-networking.outputs.vpc_peering_shared_id
}



# Crear transitgateway y unir las VPC al transit gateway


resource "aws_ec2_transit_gateway" "hub" {
  description = "Transit Gateway HUB Shared"
  amazon_side_asn = var.amazon_side_asn
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support = "enable"
  vpn_ecmp_support = "enable"
  tags = {
    Name         = "tgw-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${random_string.random.result}"
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_ec2_transit_gateway_route_table" "route-table-transit-gateway-hub" {
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  tags = {
    Name         = "rt-tgw-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${random_string.random.result}"
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

# Añadir VPC Shared
resource "aws_ec2_transit_gateway_vpc_attachment" "transit-gateway-attachment-shared" {
  subnet_ids         = data.terraform_remote_state.shared-networking.outputs.private_2_subnet-id
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id             = data.terraform_remote_state.shared-networking.outputs.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name         = "tgw-attach-shared"
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        subnet_ids, transit_gateway_id, vpc_id, tags
    ]
    #TODO: IgnoreChanges
  }
}


# Añadir VPC Dev
resource "aws_ec2_transit_gateway_vpc_attachment" "transit-gateway-attachment-dev" {
  subnet_ids         = data.terraform_remote_state.dev-networking.outputs.private_2_subnet-id
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id             = data.terraform_remote_state.dev-networking.outputs.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name         = "tgw-attach-dev"
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        subnet_ids, transit_gateway_id, vpc_id, tags
    ]
    #TODO: IgnoreChanges
  }
}

#Añadir VPC Release
resource "aws_ec2_transit_gateway_vpc_attachment" "transit-gateway-attachment-release" {
  subnet_ids         = data.terraform_remote_state.release-networking.outputs.private_2_subnet-id
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id             = data.terraform_remote_state.release-networking.outputs.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name         = "tgw-attach-release"
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
        subnet_ids, transit_gateway_id, vpc_id, tags
    ]
    #TODO: IgnoreChanges
  }
}


resource "aws_ec2_transit_gateway_route_table_association" "transit-gateway-route-association-shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit-gateway-attachment-shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.route-table-transit-gateway-hub.id
}

resource "aws_ec2_transit_gateway_route_table_association" "transit-gateway-route-association-dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit-gateway-attachment-dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.route-table-transit-gateway-hub.id
}

resource "aws_ec2_transit_gateway_route_table_association" "transit-gateway-route-association-release" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit-gateway-attachment-release.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.route-table-transit-gateway-hub.id
}