resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
}

resource "aws_vpc" "main" {
  cidr_block           = var.address_space
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags                 = merge(tomap({Name = "${var.vpcName}-${random_string.random.result}"}), var.tags)

  lifecycle {
    # No se elimina este recurso
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}