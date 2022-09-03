variable "region" {
  default = "us-east-1"
}

variable "project" {
  default = "integracam"
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "cluster_version" {
  type = string
  default = ""
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
}

variable "desired_capacity" {
  type        = string
  description = "Desired number of data nodes in the cluster"
}

variable "max_size" {
  type        = string
  description = "Maximum number of data nodes that can be run simultaneously"
}

variable "min_size" {
  type        = string
  description = "Minimum number of data nodes that can be run simultaneously"
}

variable "node_groups_defaults" {
  type        = object({
    ami_type  = string
    disk_size = number
  })
  description = "Default value for the Node Groups, please configured as pleased"
}
################################################################################
variable "Owner" {
  type        = string
  description = "User id of AWS account"
  #default     = "imendoza"
}

variable "Environment" {
  type        = string
  description = "Tipo de entorno (dev, test, pre, pro)"
  #default     = "dev"
}

variable "CostCenter" {
  type        = string
  description = "Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Atos"
  #default     = "TTAA"
}

variable "CostCenterId" {
  type        = string
  description = "Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4"
  #default     = "TTAA"
}

variable "ServiceId" {
  type        = string
  description = "Identificador unico de servicio provisto por uuid4"
  #default     = "TTAA-ARQREF"
}

variable "ProjectId" {
  type        = string
  description = "Identificador Unico de proyecto provisto por uuid4"
  #default     = "apimicroservice"
}
################################################################################
variable "BackendS3" {
  type        = string
  description = "Backend S3 of remote state for terraform"
  #default     = "s3-devsysops-711992207767-us-east-1-mbyb"
}

variable "BackendDynamoDB" {
  type        = string
  description = "Backend DynamoDB of remote state for terraform"
  #default     = "tf-up-and-running-locks-us-east-1-mbyb"
}

variable "BackendRegion" {
  type        = string
  description = "Backend region of remote state for terraform"
  #default     = "us-east-1"
}

variable "BackendProfile" {
  type        = string
  description = "Backend profile of remote state for terraform"
}