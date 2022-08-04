 variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0f25cd76"
}

# data "terraform_remote_state" "networking" {
#   backend = "s3"

#   config = {
#     bucket         = "s3-devsysops-175145454340-eu-west-1-jwyy"
#     key            = "env:/networking/terraform/dev"
#     region         = "eu-west-1"
#   }
# }

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "subnet_default" {
  vpc_id = var.vpc_id
}

## name = "rds-${var.vpcName}-${var.engine}-${ramdon_string.random.result}"



module "aurora" {
    source           = "../"
    name             = "rds-aurora-arqref"
## Engine aurora-mysql or aurora-postgresql
    engine           = "aurora-mysql"
    engine_version   = "5.7.mysql_aurora.2.07.1"
## Engine family auro-mysql5.7 or aurora-postgresql11
    engine_family    = "aurora-mysql5.7"
    vpc_id        =  "${data.aws_vpc.vpc.id}"
    vpcName       =  "default"
    subnets       =  "${data.aws_subnet_ids.subnet_default.ids}"
  # vpc_id           = "${module.vpc.vpc_id}"
  #subnets          = "${module.vpc.private-internal-subnet-id}"
    replica_count    = "3"
    instance_type    = "db.r4.large"
    skip_final_snapshot     = true
## Tipo de mensajes a Cloudwach logs
    enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
##  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres11_parameter_group.id
##  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgres11_parameter_group.id
    security_group_description = ""
}

