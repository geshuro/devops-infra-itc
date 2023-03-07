# User id of AWS account
Owner = "isaac.mendoza.external@atos.net"

# Tipo de entorno (dev, test, pre, pro)
Environment = "release"
EnvironmentShared = "shared"
# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Atos
CostCenter = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4
CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador unico de servicio provisto por uuid4
ServiceId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador Unico de proyecto provisto por uuid4
ProjectId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Number of instances
Instances = 1

# Backend S3 of remote state for terraform
BackendS3 = "s3-devsysops-841131224287-eu-west-1-jjci"

# Backend DynamoDB of remote state for terraform
BackendDynamoDB = "tf-up-and-running-locks-eu-west-1-jjci"

# Backend region of remote state for terraform
BackendRegion = "eu-west-1"

# Backend profile of remote state for terraform
BackendProfile = "atos-integracam-tf-desarrollo-ireland"

#Distribution linux
linux_distro = "centos8"

#Disk size of Kubernetes data for custom PaaS of Kubernetes
DiskSizeDataEBS = 512
#1 vcore y 1 GB RAM
InstanceType = "t2.micro"
AvailabilityZoneEBS = "eu-west-1a"

# Add Stop/Start via cron Cloudwatch
AutoStart = true
AutoStop = true