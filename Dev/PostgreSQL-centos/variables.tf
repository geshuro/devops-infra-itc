variable "Owner" {
  type        = string
  description = "User id of AWS account"
  #default     = "cdnunez-indra"
}

variable "Environment" {
  type        = string
  description = "Tipo de entorno (dev, test, pre, pro)"
  #default     = "dev"
}

variable "EnvironmentShared" {
  type        = string
  description = "Tipo de entorno (dev, test, pre, pro)"
  #default     = "shared"
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

variable "InstanceType" {
  type        = string
  description = "Instance Type of PostgreSQL Server for custom PaaS of Kubernetes"
  #default     = "t2.small"
}

variable "Instances" {
  type        = number
  description = "Number of instances of PostgreSQL for custom Cluster"
  #default     = 3
}

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
  #default     = "sunat-cuc"
}

variable "ami_id_filter" {
    type = map

    default = {
        "ubuntu20" = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*;099720109477"
        "ubuntu19" = "ubuntu/images/hvm-ssd/ubuntu-focal-19.04-amd64-server-*;099720109477"
        "ubuntu18" = "ubuntu/images/hvm-ssd/ubuntu-focal-18.04-amd64-server-*;099720109477"
        "ubuntu16" = "ubuntu/images/hvm-ssd/ubuntu-focal-16.04-amd64-server-*;099720109477"
        "ubuntu14" = "ubuntu/images/hvm-ssd/ubuntu-focal-14.04-amd64-server-*;099720109477"
        "debian9"  = "debian-stretch-*;379101102735"
        "debian8"  = "debian-jessie-*;379101102735"
        "centos8"  = "CentOS Stream 8*;125523088429"
        "centos7"  = "CentOS Linux 7*;679593333241"
        "centos6"  = "CentOS Linux 6*;679593333241"
        "rhel8"    = "RHEL-8.?*;309956199498"
        "rhel7_8"  = "RHEL-7.8_HVM-20200803-x86_64-0-Hourly2-GP2;309956199498"
        "rhel7_8_sunat"  = "Redhat-SUNAT-sinclave;711992207767"
        "rhel7"    = "RHEL-7.?*GA*;309956199498"
        "rhel6"    = "RHEL-6.?*GA*;309956199498"
    }
}


variable "linux_distro" {
    type = string
}