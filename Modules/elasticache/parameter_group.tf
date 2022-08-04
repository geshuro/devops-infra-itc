################# Redis Parameter Group #######################

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name = "${local.name}-parameter-group"

  description = "ElastiCache parameter group for ${local.name}"

  # Strip the patch version from redis_version var
  family = "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}"
  dynamic "parameter" {
    for_each = var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

