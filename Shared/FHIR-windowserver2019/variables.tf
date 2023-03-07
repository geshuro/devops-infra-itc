variable "Owner" {
  type        = string
  description = "User id of AWS account"
  #default     = "imendoza-atos"
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

variable "Instances" {
  type        = number
  description = "Number of instances of Windows Server for custom FHIR"
  #default     = 3
}

variable "InstanceType" {
  type        = string
  description = "Instance Type of PostgreSQL Server for custom PaaS of Kubernetes"
  #default     = "t2.small"
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
  #default     = "atos-integracam-tf-desarrollo"
}

variable "windows_instance_name" {
  type        = string
  description = "Name of Windows server"
  #default     = "fhir"
}

variable "windows_root_volume_size" {
  type        = number
  description = "Volumen root size"
  #default     = 60
}

variable "windows_root_volume_type" {
  type        = string
  description = "Volumen root type"
  #default     = "gp2"
}

variable "AutoStart" {
  description = "Add Start via cron Cloudwatch"
  type = bool
  default = false
}

variable "AutoStop" {
  description = "Add Stop via cron Cloudwatch"
  type = bool
  default = false
}