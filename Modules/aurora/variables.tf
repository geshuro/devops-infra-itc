
variable "create_security_group" {
  description = "Whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name given resources"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}

variable "replica_count" {
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
  default     = 1
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpcName" {
  description = "VPC Name"
  type        =  string
  
}
variable "instance_type" {
  description = "Instance type to use"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP address"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "password" {
  description = "Master DB password"
  type        = string
  default     = ""
}

variable "secret_name" {
  description = "Name of secret to store"
  type        = string
  default     = ""
}

variable "secret_values" {
  description = "Db Secrets "
  type = map
  default = {
    username = "root"
    password = "123456789"
  }
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "port" {
  description = "The port on which to accept connections"
  type        = string
  default     = ""
}


variable "db_parameter_group_name" {
  description = "The name of a DB parameter group to use"
  type        = string
  default     = ""
}

variable "db_cluster_parameter_group_name" {
  description = "The name of a DB Cluster parameter group to use"
  type        = string
  default     = ""
}


variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  type        = string
  default     = "aurora"
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = "5.6.10a"
}

variable "engine_family"  {
  description = "Aurora database engine family - Db Parameters Group"
  type        = string
  default     = "aurora-postgresql11"
}
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {
       Enviroment = "pro"
       CostCenter = ""
       ServiceId  = ""
       ProjectId  = ""
  }
}


variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = ["postgresql"]
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = ""
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless."
  type        = string
  default     = "provisioned"
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if aurora_arqref DB cluster is to be created as a Read Replica."
  default     = ""
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster."
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in aurora_arqref module"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "The existing subnet group name to use"
  type        = string
  default     = ""
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set aurora_arqref value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)"
  type        = number
  default     = 0
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 60
}

variable "iam_roles" {
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster."
  type        = list(string)
  default     = []
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description."
  type        = string
  default     = "Managed by Terraform"
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-2019"
}

variable "cpu_utilization_threshold" {
  description = "CPU alarm DB Instance threshold"
  type        = number
  default     = 82
}

variable "cpu_credit_balance_threshold" {
  description = " CPU credit balance threshold "
  type        = number
  default     = 20
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = string
  default     = 64000000

  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = string
  default     = 2000000000

  # 2 Gigabyte in Byte
}

variable "zone_name" {
  description = "Internal DNS zone id"
  type        =  string
  default     =  ""
}

variable "db_mysql_parameters" {
  description = "additional parameters mysql db modifyed in parameter group"
  type        = list(map(any))
  default     = [
                {
                name  = "log_bin_trust_function_creators"
                value = "1"
                },
                {
                name  = "innodb_print_all_deadlocks"
                value = "1"
                },
                {
                name  = "max_allowed_packet"
                value = "1073741824"
                },
                {
                name  = "event_scheduler"
                value = "ON"
                },
                {
                name  = "interactive_timeout"
                value = "28800"
                }
                ]
}
variable "db_cluster_mysql_parameters" {
  description = "additional parameters mysql db modifyed in parameter group"
  type        = list(map(any))
  default     =  [
                  {
                  name  = "character_set_server"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_client"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_connection"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_database"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_filesystem"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_results"
                  value = "utf8"
                  },
                  {
                  name  = "character_set_server"
                  value = "utf8"
                  },
                  {
                  name  = "collation_connection"
                  value = "utf8_general_ci"
                  },
                  {
                  name  = "collation_server"
                  value = "utf8_general_ci"
                  }
                ]
}

variable "sns_topic_arn_alarm" {
  description = "SNS Topic to CloudWatch Alarms"
  type = list(string)
  #default = ["arn:aws:sns:eu-west-1:175145454340:sns-rds-default-aurora-mysql-aju"]
}