data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnets
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.public_subnet-count
  cidr_block              = element(var.cidr_block_public_subnet, count.index)
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index % length(data.aws_availability_zones.available.zone_ids)]
  map_public_ip_on_launch = "true"
  tags                    = merge(tomap({Name = format("sn-%s-pub-n1-z%s", aws_vpc.main.tags["Name"], substr(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)], length(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)]) - 1, 1))}), tomap({"kubernetes.io/role/elb" = "1"}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      tags,
    ]
  }
}
resource "aws_subnet" "bastion-nat-subnet" {
  depends_on = [aws_subnet.public-subnet]
  vpc_id     = aws_vpc.main.id
  count      = var.bastion_nat_subnet-count
  #cidr_block              = cidrsubnet(var.address_space, 11, count.index + var.public_subnet-count)
  #cidr_block              = cidrsubnet(var.cidr_block_bastion_nat_subnet, 4, count.index + var.public_subnet-count)  
  cidr_block              = element(var.cidr_block_bastion_nat_subnet, count.index)
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index % length(data.aws_availability_zones.available.zone_ids)]
  map_public_ip_on_launch = "true"
  tags                    = merge(tomap({Name = format("sn-%s-nat-n1-z%s", aws_vpc.main.tags["Name"], substr(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)], length(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)]) - 1, 1))}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      tags,
    ]
  }
}

# Private Subnets
resource "aws_subnet" "private-lb-subnet" {
  depends_on           = [aws_subnet.private-subnet]
  vpc_id               = aws_vpc.main.id
  count                = var.private_lb_subnet-count
  cidr_block           = element(var.cidr_block_private-lb-subnet, count.index)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index % length(data.aws_availability_zones.available.zone_ids)]
  tags                 = merge(tomap({Name = format("sn-%s-pri-n1-z%s", aws_vpc.main.tags["Name"], substr(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)], length(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)]) - 1, 1))}), tomap({"kubernetes.io/role/internal-elb" = "1"}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "private-subnet" {
  depends_on           = [aws_subnet.bastion-nat-subnet]
  vpc_id               = aws_vpc.main.id
  count                = var.private_subnet-count
  cidr_block           = element(var.cidr_block_private-subnet, count.index)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index % length(data.aws_availability_zones.available.zone_ids)]
  tags                 = merge(tomap({Name = format("sn-%s-pri-n2-z%s", aws_vpc.main.tags["Name"], substr(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)], length(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)]) - 1, 1))}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "private-internal-subnet" {
  depends_on           = [aws_subnet.private-lb-subnet]
  vpc_id               = aws_vpc.main.id
  count                = var.private_internal_subnet-count
  cidr_block           = element(var.cidr_block_private-internal-subnet, count.index)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index % length(data.aws_availability_zones.available.zone_ids)]
  tags                 = merge(tomap({Name = format("sn-%s-int-n1-z%s", aws_vpc.main.tags["Name"], substr(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)], length(data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.zone_ids)]) - 1, 1))}), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      tags,
    ]
  }
}
