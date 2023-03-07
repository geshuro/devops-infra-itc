###############################################################################################################
# "El CIRD asignado al VPC, se establece con una mascara de red no superior de una /24 y no inferior de una /16"
vpcCIRD = "10.36.14.0/23"

# "Nombre del VPC"
vpcName = "vpcpro"

# En base al CIRD proporcionado, seleccionar un plan de subnetting Se debe indicar alguno de los siguientes valores (Mask21, Mask22, Mask23, Mask24, Mask22-Int) Mask22 es el plan #default. Atiende al nombre de cabecera dado a los mapas de red
Maskplan = "Mask23v2"

# Se crea la zona interna 
CreateRoute53 = "false"

# Nombre de la zona Id creada
InternalZoneId = "Z08995941R5S5BAXFUMRU"

# El nombre que recibe la zona interna, se puede atomatizar, pero funcionalmente y por operacion se considera dejarla de forma manual
DNSInternalName = "atos-integracam.int"

# Tipo de entorno, sh, dev, qa, test, pre, pro
Environment = "pro"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por Atos
CostCenter = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Centro de coste aplicado a la cuenta, servicio o proyecto provisto por uuid 4
CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador unico de servicio provisto por uuid4
ServiceId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Identificador Unico de proyecto provisto por uuid4
ProjectId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"

# Crear VPC Peering para activarlo true
VPCPeeringEnableShared = "true"

# VPC Id del destino
destinoVPCIdShared = "vpc-017a03e00e2933b0e"

# Descripcion de la conexion peering
DescriptionVPCPeeringShared = "VPC Peering Production to Shared"

# CIRD Asignado al VPC de Shared
vpcCIRDShared = "10.36.8.0/23"