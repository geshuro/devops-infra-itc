# User id of AWS account
Owner = "imendoza-atos"

# Tipo de entorno (dev, test, pre, pro)
Environment = "dev"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Indra
CostCenter = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4
CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador unico de servicio provisto por uuid4
ServiceId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador Unico de proyecto provisto por uuid4
ProjectId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Number of instances of postgresql
Instances = 1

# Internal domain of cloud infraestructure
InternalDomain = "integracam.int"

# Backend S3 of remote state for terraform
BackendS3 = "s3-devsysops-841131224287-us-east-1-bvvy"

# Backend DynamoDB of remote state for terraform
BackendDynamoDB = "tf-up-and-running-locks-us-east-1-bvvy"

# Backend region of remote state for terraform
BackendRegion = "us-east-1"

# Backend profile of remote state for terraform
BackendProfile = "atos-integracam-tf-desarrollo"

# Zone id of Route53
ZoneIdRoute53 = "Z083667737ZSMKCBP9ZPT"

#Distribution linux
linux_distro = "centos8"

#2 vcores y 4GB RAM
InstanceType = "t3a.medium"
AvailabilityZoneEBS = "us-east-1a"