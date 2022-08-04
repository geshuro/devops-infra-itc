
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

data "aws_vpc" "vpc_default" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "subnet_default" {
  vpc_id = var.vpc_id
}


module "efs" {
  source        = "../"
#  vpc_id        = "${data.terraform_remote_state.networking.outputs.vpc_id}"
#  vpc_id        = "${module.vpc.vpc_id}"
  vpc_id        =  "${data.aws_vpc.vpc_default.id}"
  name          = "efs-arqref"
  subnet_ids    =  "${data.aws_subnet_ids.subnet_default.ids}"
  vpcName	=  "default"
 # subnet_ids    = "${data.terraform_remote_state.networking.outputs.private-internal-subnet-id}"
 # subnet_ids    =  "${module.vpc.private-internal-subnet-id}"
 
}
