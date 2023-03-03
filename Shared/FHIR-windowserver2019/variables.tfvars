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

# Number of instances
Instances = 1

# Type of instance = 4 vcores y 16GB RAM
InstanceType = "t3a.xlarge"

# Backend S3 of remote state for terraform
BackendS3 = "s3-devsysops-841131224287-eu-west-1-jjci"

# Backend DynamoDB of remote state for terraform
BackendDynamoDB = "tf-up-and-running-locks-eu-west-1-jjci"

# Backend region of remote state for terraform
BackendRegion = "eu-west-1"

# Backend profile of remote state for terraform
BackendProfile = "atos-integracam-tf-desarrollo-ireland"

# Name of Windows server
windows_instance_name = "fhir"

# Volumen root
windows_root_volume_size            = 360
windows_root_volume_type            = "gp2"

# Volumen extra
#windows_data_volume_size            = 300
#windows_data_volume_type            = "gp2"

# Add Stop/Start via cron Cloudwatch
AutoStart = true
AutoStop = true