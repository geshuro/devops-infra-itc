
## DB Aurora PostGres Paremeter Group  ##
resource "aws_db_parameter_group" "aurora_db_postgres11_parameter_group" {
  count       = var.engine == "aurora-postgresql" ? 1 : 0
  name        = "${local.name}-parameter-group"
  family      = var.engine_family
  description = "${local.name}-parameter-group"
  
  tags = merge(var.tags, {
    Name = "${local.name}-parameter-group"
  })

}

## DB Aurora Cluster PostGresParameter Group
resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres11_parameter_group" {
  count       = var.engine == "aurora-postgresql" ? 1 : 0
  name        = "${local.name}-cluster-parameter-group"
  family      = var.engine_family
  description = "${local.name}-cluster-parameter-group"

  tags = merge(var.tags, {
    Name = "${local.name}-cluster-parameter-group"
  })
}

## DB Aurora MySQL Parameter Group  ##
resource "aws_db_parameter_group" "aurora_db_mysql_parameter_group" {
  count        = var.engine == "aurora-mysql" ? 1 : 0
  name         = "${local.name}-parameter-group"
  family       = var.engine_family
  description  = "${local.name}-parameter-group"

  dynamic "parameter" {
    for_each = var.db_mysql_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  } 
  tags         = merge(var.tags, {
    Name = "${local.name}-parameter-group"
  }) 
}

## DB Aurora My SQL Cluster Parameter Group

resource "aws_rds_cluster_parameter_group" "aurora_cluster_mysql_parameter_group" {
  count        = var.engine == "aurora-mysql" ? 1 : 0
  name         = "${local.name}-cluster-parameter-group"
  family       = var.engine_family
  description  = "${local.name}-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.db_cluster_mysql_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  } 
  

  tags = merge(var.tags, {
    Name      = "${local.name}-cluster-parameter-group"
  }) 
}


