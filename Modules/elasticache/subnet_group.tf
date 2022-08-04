#################### DB Subnet ##################################
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  count       = var.ec_subnet_group_name == "" ? 1 : 0  
  name        = "db-sn-${local.name}"
  description = "For Elasticache cluster ${local.name}"
  subnet_ids  = var.subnet_ids
#   tags = merge(var.tags, {
#            Name = "db-sn-${local.name}"
#   })
}
