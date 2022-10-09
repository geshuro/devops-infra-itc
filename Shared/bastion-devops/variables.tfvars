# "Nombre del bucket configurado para el backend"
s3backend = "s3-devsysops-841131224287-eu-west-1-jjci"

# "Nombre del bucket configurado para devops"
s3devops = "s3-devsysops-841131224287-eu-west-1-jjci"
 
# "Nombre de la tabla de dynamodb para el backend"
dynamobackend = "tf-up-and-running-locks-eu-west-1-jjci"
 
# "Nombre de la region del backend"
regionbackend = "eu-west-1"
 
# "Nombre del profile con permisos de acceso al backend"
profilebackend = "atos-integracam-tf-desarrollo-ireland"

# "Al tener varios entornos se debe utilizar esta variable para identificar en donde se encuentra el status del backend para shared"
#EnvironmentbackendShared = "dev"

# Tipo de entorno, shared, dev, qa, test, pre, pro
Environment = "shared"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Indra
CostCenter = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4
CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador unico de servicio provisto por uuid4
ServiceId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador Unico de proyecto provisto por uuid4
ProjectId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Dentro de un entorno el nivel donde se encuentra
stage = "shared"

# Nombre del grupo de application
name = "bastion-devops"

# Add Stop/Start via cron Cloudwacht
AutoStart = false
AutoStop = true
### SNS ###########

# "Email for sns notifications"
#subscriptions_emails = "imendozah@atos.com, imendozah@atos.com"

#instance_type = "t3.medium"
instance_type = "t3.small"

ssh_public_key_path = "./secret"
generate_ssh_key = true