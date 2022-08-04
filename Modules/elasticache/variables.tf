
variable "alarm_cpu_threshold" {
  description = "Alarm Elasticache CPU Threshold"
  default     = "80"
}

variable "alarm_memory_threshold" {
  description = "Alarm Elasticache Memory Threshold"
  # 10MB
  default = "67108864"
}

variable "alarm_evictions_threshold" {
  description = "Alarm Elasticache Evictions"
  default     =  "1000"
}

variable "alarm_replication_lag_threshold" {
  description = "Alarm Elasticache Evictions"
  default     =  "1000"
}

variable "sns_topic_arn_alarm" {
  description = "SNS Topic to CloudWatch Alarms"
  type = list(string)
  default = ["arn:aws:sns:eu-west-1:175145454340:sns-rds-default-aurora-mysql-aju"]
}


variable "apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
  type        = bool
  default     = false
}

variable "allowed_cidr" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = ["127.0.0.1/32"]
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

# variable "env" {
#   description = "env to deploy into, should typically dev/staging/prod"
#   type        = string
# }

variable "name" {
  description = "Name for the Redis replication group i.e. UserObject"
  type        = string
}

variable "redis_clusters" {
  description = "Number of Redis cache clusters (nodes) to create"
  type        = string
}

variable "redis_failover" {
  type    = bool
  default = false
}

variable "redis_node_type" {
  description = "Instance type to use for creating the Redis cache clusters"
  type        = string
  default     = "cache.t2.micro"
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group"
}

variable "security_groups" {
  description = "List security group"
  type        = list(string)
}

# might want a map
variable "redis_version" {
  description = "Redis version to use, defaults to 3.2.10"
  type        = string
  default     = "5.0.6" //"3.2.10"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpcName" {
  description = "VPC Name"
  type        =  string
  
}

variable "redis_parameters" {
  description = "additional parameters modifyed in parameter group"
  type        = list(map(any))
  default     = []
}

variable "redis_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  type        = string
  default     = "fri:08:00-fri:09:00"
}

variable "redis_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period"
  type        = string
  default     = "06:30-07:30"
}

variable "redis_snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  type        = number
  default     = 0
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

variable "ec_subnet_group_name" {
    description = "Elasticache DB Subnet Name"
    type        = string
    default     = ""
}

variable "create_security_group" {
    description = "Create Elasticache Security Group Y/N"
    type        = bool
    default     = true
}

variable "redis_rest_encryption_enabled" {
    description = "Enable Encryption at Rest Elasticache"
    type        = bool
    default     = false

}

variable "redis_transit_encryption_enabled" {
    description = "Enable Encryption at Rest Elasticache"
    type        = bool
    default     = false
 
}

variable "zone_name" {
  description = "Internal DNS zone id"
  type        =  string
  default     =  ""
}