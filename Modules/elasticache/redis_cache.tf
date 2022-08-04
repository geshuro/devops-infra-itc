locals {
    name                                 = "ec-redis-${var.vpcName}-${random_string.random.result}"
    #redis_security_group_id              = join("", aws_security_group.redis_arqref.*.id)
    ec_subnet_group_name                 = var.ec_subnet_group_name == "" ? join("", aws_elasticache_subnet_group.redis_subnet_group.*.name) : var.ec_subnet_group_name
}
# data "aws_vpc" "vpc" {
#   id = var.vpc_id
# }

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
}

resource "random_id" "salt" {
  byte_length = 8
}

########################Cluster Redis #######################

resource "aws_elasticache_replication_group" "redis_arqref" {
  replication_group_id          = var.name
  replication_group_description = "Elasticache replication group for ${local.name}"
  number_cache_clusters         = var.redis_clusters
  node_type                     = var.redis_node_type
  automatic_failover_enabled    = var.redis_failover
  engine_version                = var.redis_version
  port                          = var.redis_port
  parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.id
  subnet_group_name             = local.ec_subnet_group_name
  security_group_ids            = var.security_groups
  apply_immediately             = var.apply_immediately
  maintenance_window            = var.redis_maintenance_window
  snapshot_window               = var.redis_snapshot_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  at_rest_encryption_enabled    = var.redis_rest_encryption_enabled
  transit_encryption_enabled    = var.redis_transit_encryption_enabled
  tags                          = merge(var.tags, {Name = "ec-${local.name}"})
  }