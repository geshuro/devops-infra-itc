# Basado en https://github.com/terraform-aws-modules/terraform-aws-rds-aurora
#####    Variables Locales  ##########################

locals {
  port                         = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  master_password              = var.password == "" ? random_password.master_password.result : var.password
  db_subnet_group_name         = var.db_subnet_group_name == "" ? join("", aws_db_subnet_group.aurora_arqref.*.name) : var.db_subnet_group_name
  backtrack_window             = (var.engine == "aurora-mysql" || var.engine == "aurora") && var.engine_mode != "serverless" ? var.backtrack_window : 0
  rds_enhanced_monitoring_arn  = join("", aws_iam_role.rds_enhanced_monitoring.*.arn)
  rds_enhanced_monitoring_name = join("", aws_iam_role.rds_enhanced_monitoring.*.name)
  rds_security_group_id        = join("", aws_security_group.aurora_arqref.*.id)
  name                         = "rds-${var.vpcName}-${var.engine}-${random_string.random.result}"
  db_parameter_cluster_group   = var.db_cluster_parameter_group_name == "" ? var.engine == "aurora-postgresql" ? join("",aws_rds_cluster_parameter_group.aurora_cluster_postgres11_parameter_group.*.id) : join("",aws_rds_cluster_parameter_group.aurora_cluster_mysql_parameter_group.*.id): var.db_cluster_parameter_group_name
  db_parameter_group_name      = var.db_parameter_group_name == "" ? var.engine == "aurora-postgresql" ? join("",aws_db_parameter_group.aurora_db_postgres11_parameter_group.*.id) : join("",aws_db_parameter_group.aurora_db_mysql_parameter_group.*.id) : var.db_parameter_group_name
  username                     = var.secret_name == "" ? jsondecode(join("",aws_secretsmanager_secret_version.secret.*.secret_string))["username"] : jsondecode(join("",data.aws_secretsmanager_secret_version.db_secret_sec.*.secret_string))["username"]
  password                     = var.secret_name == "" ? jsondecode(join("",aws_secretsmanager_secret_version.secret.*.secret_string))["password"] : jsondecode(join("",data.aws_secretsmanager_secret_version.db_secret_sec.*.secret_string))["password"]
}

data "aws_vpc" "main" {
  id = "${var.vpc_id}"
}
resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
}

## Random string to use as master password unless one is specified
resource "random_password" "master_password" {
  length  = 10
  special = false
 }

######### Db Cluster ###########################################

resource "aws_rds_cluster" "aurora_arqref" {
  global_cluster_identifier           = var.global_cluster_identifier
  cluster_identifier                  = local.name
  replication_source_identifier       = var.replication_source_identifier
  source_region                       = var.source_region
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  kms_key_id                          = var.kms_key_id
  database_name                       = var.database_name
  master_username                     = local.username
  master_password                     = local.password
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${local.name}-${random_id.snapshot_identifier.hex}"
  skip_final_snapshot                 = var.skip_final_snapshot
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  port                                = local.port
  db_subnet_group_name                = local.db_subnet_group_name
  vpc_security_group_ids              = compact(concat(aws_security_group.aurora_arqref.*.id, var.vpc_security_group_ids))
  storage_encrypted                   = var.storage_encrypted
  #db_cluster_parameter_group_name     = local.db_parameter_cluster_group
  #db_cluster_parameter_group_name     = "default"
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  backtrack_window                    = local.backtrack_window
  iam_roles                           = var.iam_roles

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = merge(var.tags, {
    Name = "${local.name}"
  })
}

###########   Db Instances  ######################################

resource "aws_rds_cluster_instance" "aurora_arqref" {
  count = var.replica_count

  identifier                      = "${local.name}-${count.index + 1}"
  cluster_identifier              = aws_rds_cluster.aurora_arqref.id
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_type
  publicly_accessible             = var.publicly_accessible
  db_subnet_group_name            = local.db_subnet_group_name
  #db_parameter_group_name         = local.db_parameter_group_name
  #db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres11_parameter_group.id
  promotion_tier                  = count.index + 1
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = local.rds_enhanced_monitoring_arn
  ca_cert_identifier              = var.ca_cert_identifier

   tags = merge(var.tags, {
    Name = "${local.name}-${count.index + 1}"
  })
}

# resource "aws_db_parameter_group" "aurora_db_postgres11_parameter_group" {
#   name        = "test-aurora-db-postgres11-parameter-group"
#   family      = "aurora-postgresql11"
#   description = "test-aurora-db-postgres11-parameter-group"
# }

# resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres11.6_parameter_group" {
#   name        = "test-aurora-postgres11.6-cluster-parameter-group"
#   family      = "aurora-postgresql11.6"
#   description = "test-aurora-postgres11.6-cluster-parameter-group"
# }


### Random para Snapshop ##

resource "random_id" "snapshot_identifier" {
  keepers = {
    id = local.name
  }

  byte_length = 4
}

#  ## Iam Roles para la monitorizacion  ###

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name               = "enhanced-monitoring-${local.name}"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  role       = local.rds_enhanced_monitoring_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}



