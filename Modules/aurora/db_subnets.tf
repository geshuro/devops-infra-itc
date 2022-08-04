
###   DB Subnet #####################################

resource "aws_db_subnet_group" "aurora_arqref" {
  count = var.db_subnet_group_name == "" ? 1 : 0

  name        = "db-sn-${local.name}"
  description = "For Aurora cluster ${local.name}"
  subnet_ids  = var.subnets

  tags = merge(var.tags, {
    Name = "db-sn-${local.name}"
  })
}