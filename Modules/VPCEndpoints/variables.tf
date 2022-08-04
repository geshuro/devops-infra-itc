variable "nat-gw-count" {}        # Numbers of NAT GW created
variable "subnets-id" {}          # Lists of Subnets IDs created
variable "route-table-private-za" {} # RouteTable of PrivateSubnets
/* imendoza variable "route-table-private-zb" {} # RouteTable of PrivateSubnets */

variable "main_vpc" {
  type        = string
  description = "Main VPC ID that will be associated with this hosted zone"
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = true
}