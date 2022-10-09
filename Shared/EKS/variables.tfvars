region  = "eu-west-1"

project = "integracam"

cluster_version = "1.23"

#instance_type = "m5.large"
#2 cpu 8gb
instance_type = "t3a.large" 

desired_capacity = 1

max_size = 3

min_size = 1

# User id of AWS account
Owner = "isaac.mendoza.external@atos.net"

# Tipo de entorno (dev, test, pre, pro)
Environment = "shared"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Atos
CostCenter = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4
CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador unico de servicio provisto por uuid4
ServiceId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador Unico de proyecto provisto por uuid4
ProjectId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"





# Backend S3 of remote state for terraform
BackendS3 = "s3-devsysops-841131224287-eu-west-1-jjci"

# Backend DynamoDB of remote state for terraform
BackendDynamoDB = "tf-up-and-running-locks-eu-west-1-jjci"

# Backend region of remote state for terraform
BackendRegion = "eu-west-1"

# Backend profile of remote state for terraform
BackendProfile = "atos-integracam-tf-desarrollo-ireland"

map_users = [
    {
      userarn  = "arn:aws:iam::841131224287:user/isaac.mendoza.external@atos.net"
      username = "isaac"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::841131224287:user/leyla.ordonez@atos.net"
      username = "leyla"
      groups   = ["system:masters"]
    },
]