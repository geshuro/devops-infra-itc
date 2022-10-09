variable "profile" {
  type        = string
}

variable "key" {
  type        = string
}

variable "region" {
  type        = string
}

variable "dynamodb_table" {
  type        = string
}

variable "s3backend" {
  description = "Nombre del bucket configurado para el backend"
  type        = string
}

variable "s3devops" {
  description = "Nombre del bucket configurado para las configuraciones de infarestructuras y aplicaciones, es posible que sea el mismo que backend"
  type        = string
}

variable "vpc_id" {
  default = "ID del vpc donde se crea el Bastion"
  type    = string
}

variable "Environment" {
  type        = string
  description = "Referencia al entorno dev,qa,test,staging,pro,pre"
}

variable "ProjectId" {
  type        = string
  description = "pid- Identificador unico para el proyecto, este numero podemos asociarlo posteriormente con un nombre"
}

variable "CostCenter" {
  type        = string
  description = "cc- Identificador, para los tags y resolucion de costes"
}

variable "ServiceId" {
  type        = string
  description = "sid- Identificador unico del servicio"
}

variable "namespace" {
  type        = string
  description = "Abreviatura del elemento que vamos a crear"
}

variable "stage" {
  type        = string
  description = "Referencia al entorno dev,qa,test,staging,pro,pre puede ser distinto a environment"
}

variable "name" {
  type        = string
  description = "Nombre de la aplicacion o elemento que queremos generar"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path para almacenar los SSH public key directory (e.g. `/secrets`)"
}

variable "generate_ssh_key" {
  type        = bool
  description = "Si es `true`, se crea una nueva key pair"
}

# variable "region" {
#     type = string
#     description = "The AWS region to deploy into (e.g. us-east-1)"
# }

# variable "project" {
#     type = string
#     description = "Name of the project these resources are being created for"
# }

# variable "creator" {
#     type = string
#     description = "Person creating these resources"
# }

# variable "environment" {
#     type = string
#     description = "Context these resources will be used in, e.g. production"
# }

# variable "freetext" {
#     type = string
#     description = "Information that does not fit in the other tags"
# }

variable "instance_type" {
  type        = string
  description = "Instance type to make the Bastion host from"
}

# variable "ssh_key_name" {
#     type = string
#     description = "Name of the SSH key pair to use when logging into the bastion host"
# }

variable "max_size" {
  type        = string
  description = "Maximum number of bastion instances that can be run simultaneously"
}

variable "min_size" {
  type        = string
  description = "Minimum number of bastion instances that can be run simultaneously"
}

variable "cooldown" {
  type        = string
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
}

variable "health_check_grace_period" {
  type        = string
  description = "Time, in seconds, after instance comes into service before checking health."
}

variable "desired_capacity" {
  type        = string
  description = "The number of bastion instances that should be running in the group."
}

variable "scale_down_desired_capacity" {
  type        = string
  description = "The number of bastion instances that should be running when scaling down."
}

variable "scale_down_min_size" {
  type        = string
  description = "Minimum number of bastion instances that can be running when scaling down"
}

variable "enabledcronweekend" {
  type        = bool
  description = "If exist cron for weekend down/up"
  default     = false
}
variable "cronweekenddown" {
  type = object({
    cron       = string
    start_time = string
    end_time   = string
  })
  default = {
    cron       = "0 3 * * SAT"
    start_time = "2022-06-19T18:00:30Z"
    end_time   = "2030-06-19T18:00:30Z"
  }
}
variable "cronweekendup" {
  type = object({
    cron       = string
    start_time = string
    end_time   = string
  })
  default = {
    cron       = "0 6 * * MON"
    start_time = "2022-06-19T18:00:00Z"
    end_time   = "2030-06-19T18:00:00Z"
  }
}

# variable "public_ssh_key" {
#     type = string
#     description = "Public half of the SSH key to import into AWS"
# }

# variable "security_group_ids" {
#     type = "list"
#     description = "List of security groups to apply to the instances"
# }