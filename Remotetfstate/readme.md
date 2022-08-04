## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Variables

| Name | Description |
|------|-------------|
| region | Region donde se desplegara estos recursos, no tiene que ser la cuenta donde se va a desplegar la infraestructura posterior.  |
| profile | Este valor se debe de establecer entre el equipo, porque debe configurarse el mismo para poder trabajar de forma colaborativa |
| CostCenter  | Identificador para el codigo de imputacion |
| CosteCenterId | Identificador-unico-sin-espacios asignado como etiqueta de coste |
| EntityName| Nombre de la Entidad a la que se suscribe el recurso |
| EntityId | id-de-la-entidad-sin-espacios |
| ProjectName | Nombre del proyecto|
| ProjectId  | id-del-proyecto-sin-espacios|
| ServiceName | Nombre del servicio |
| ServiceId| id-del-servicio-sin-espacios|
| Environment | Entorno al que hace referencia, lo normal es all, qque indica que contendra la configuracion de todos los entornos, sino colocar dev, qa, test, pre o pro |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| dynamodb\_table\_name\_arn | The name of the DynamoDB table |
| dynamodb\_table\_name\_id | The name of the DynamoDB table |
| s3\_bucket\_arn | The ARN of the S3 bucket |
| s3\_bucket\_domain\_name | The ARN of the S3 bucket |
| s3\_bucket\_id | The ARN of the S3 bucket |

