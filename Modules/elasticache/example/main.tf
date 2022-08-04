
  variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0f25cd76"
}

 variable "vpcName" {
  description = "VPC Name"
  type        =  string
  default     =  "default"
   
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


# module "efs" {
#   source        = "../"
# #  vpc_id        = "${data.terraform_remote_state.networking.outputs.vpc_id}"
# #  vpc_id        = "${module.vpc.vpc_id}"
#   vpc_id        =  "${data.aws_vpc.vpc_default.id}"
#   name          = "efs-arqref"
#   subnet_ids    =  "${data.aws_subnet_ids.subnet_default.ids}"
#  # subnet_ids    = "${data.terraform_remote_state.networking.outputs.private-internal-subnet-id}"
#  # subnet_ids    =  "${module.vpc.private-internal-subnet-id}"
#   tags          = {
#                     proyect = "Arquitectura Referencia API - Microservicios",
#                     company = "Minsait",
#                     terraform = "true"
#   }
# }

module "elasticache" {
    source         = "../"
    name           = "elasticache-arqref"
    redis_clusters = "3" 
    vpc_id         =  "${data.aws_vpc.vpc.id}"
    subnet_ids     =  "${data.aws_subnet_ids.subnet_default.ids}"
    vpcName        =   var.vpcName
    redis_failover = true

#    vpc_id         = "${data.aws_vpc.selected.id}"
#    subnet_ids     = "${data.aws_subnet_ids.private_internal_arqref.ids}"
#    vpc_id        = "${module.vpc.vpc_id}"
#    subnet_ids    = "${module.vpc.private-internal-subnet-id}"
}
    