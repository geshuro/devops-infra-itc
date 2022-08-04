## Descripcion Modulo  
El objetivo del modulo es provisionar una VPC con los siguientes componentes:
    - 3 Subnets publicas
    - 3 Subnets públicas (bastion)
    - 3 Subnets privadas 
    - 3 Subnets privadas (LB)
    - 3 Subnets privadas internas
    - Tablas de Rutas y asociaciones de rutas
    - 1 Internet Gateway
    - 3 NAT Gateways
    - 3 EIP asociadas a los NAT GW.
    - NACLs y Reglas
    - Route53 internal

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| AWS\_REGION | Global variables | `string` | `"eu-west-1"` | no |
| Route53name | Name of the hosted zone | `string` | n/a | yes |
| address\_space | The address space that is used by the vpc. | `string` | n/a | yes |
| bastion\_nat\_subnet-count | n/a | `any` | n/a | yes |
| cidr\_block\_bastion\_nat\_subnet | CIDR block of the VPC | `list` | n/a | yes |
| cidr\_block\_private-internal-subnet | CIDR block of the VPC | `list` | n/a | yes |
| cidr\_block\_private-lb-subnet | CIDR block of the VPC | `list` | n/a | yes |
| cidr\_block\_private-subnet | CIDR block of the VPC | `list` | n/a | yes |
| cidr\_block\_public\_subnet | CIDR block of the VPC | `list` | n/a | yes |
| codebuild\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for Codebuild endpoint | `bool` | `false` | no |
| codebuild\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for Codebuild endpoint | `list` | `[]` | no |
| codebuild\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for Codebuilt endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list` | `[]` | no |
| create\_vpc | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| enable\_apigw\_endpoint | Should be true if you want to provision an api gateway endpoint to the VPC | `bool` | `false` | no |
| enable\_appmesh\_envoy\_management\_endpoint | Should be true if you want to provision a AppMesh endpoint to the VPC | `bool` | `false` | no |
| enable\_cloud\_directory\_endpoint | Should be true if you want to provision an Cloud Directory endpoint to the VPC | `bool` | `false` | no |
| enable\_cloudtrail\_endpoint | Should be true if you want to provision a CloudTrail endpoint to the VPC | `bool` | `false` | no |
| enable\_codebuild\_endpoint | Should be true if you want to provision an Codebuild endpoint to the VPC | `bool` | `false` | no |
| enable\_codecommit\_endpoint | Should be true if you want to provision an Codecommit endpoint to the VPC | `bool` | `false` | no |
| enable\_codepipeline\_endpoint | Should be true if you want to provision a CodePipeline endpoint to the VPC | `bool` | `false` | no |
| enable\_config\_endpoint | Should be true if you want to provision an config endpoint to the VPC | `bool` | `false` | no |
| enable\_dynamodb\_endpoint | Should be true if you want to provision a DynamoDB endpoint to the VPC | `bool` | `false` | no |
| enable\_ecr\_api\_endpoint | Should be true if you want to provision an ecr api endpoint to the VPC | `bool` | `false` | no |
| enable\_ecr\_dkr\_endpoint | Should be true if you want to provision an ecr dkr endpoint to the VPC | `bool` | `false` | no |
| enable\_ecs\_endpoint | Should be true if you want to provision a ECS endpoint to the VPC | `bool` | `false` | no |
| enable\_efs\_endpoint | Should be true if you want to provision an EFS endpoint to the VPC | `bool` | `false` | no |
| enable\_elasticloadbalancing\_endpoint | Should be true if you want to provision a Elastic Load Balancing endpoint to the VPC | `bool` | `false` | no |
| enable\_events\_endpoint | Should be true if you want to provision a CloudWatch Events endpoint to the VPC | `bool` | `false` | no |
| enable\_git\_codecommit\_endpoint | Should be true if you want to provision an Git Codecommit endpoint to the VPC | `bool` | `false` | no |
| enable\_kms\_endpoint | Should be true if you want to provision a KMS endpoint to the VPC | `bool` | `false` | no |
| enable\_logs\_endpoint | Should be true if you want to provision a CloudWatch Logs endpoint to the VPC | `bool` | `false` | no |
| enable\_monitoring\_endpoint | Should be true if you want to provision a CloudWatch Monitoring endpoint to the VPC | `bool` | `false` | no |
| enable\_s3\_endpoint | Should be true if you want to provision an S3 endpoint to the VPC | `bool` | `false` | no |
| enable\_secretsmanager\_endpoint | Should be true if you want to provision an Secrets Manager endpoint to the VPC | `bool` | `false` | no |
| enable\_sns\_endpoint | Should be true if you want to provision a SNS endpoint to the VPC | `bool` | `false` | no |
| enable\_ssm\_endpoint | Should be true if you want to provision an SSM endpoint to the VPC | `bool` | `false` | no |
| force\_destroy | Whether to destroy all records inside if the hosted zone is deleted | `string` | `false` | no |
| main\_vpc | Main VPC ID that will be associated with this hosted zone | `string` | n/a | yes |
| nat-gw-count | n/a | `any` | n/a | yes |
| private\_internal\_subnet-count | n/a | `any` | n/a | yes |
| private\_lb\_subnet-count | n/a | `any` | n/a | yes |
| private\_subnet-count | n/a | `any` | n/a | yes |
| public\_subnet-count | n/a | `any` | n/a | yes |
| route-table-count | n/a | `any` | n/a | yes |
| tags | A map of tags to add networking resources | `map` | <pre>{<br>  "CostCenter": "",<br>  "Environment": "pro",<br>  "ProjectId": "",<br>  "ServiceId": ""<br>}</pre> | no |
| vpcName | Name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_route\_table-private\_internal\_subnet-ids | ################ # ROUTE TABLES # ################ |
| aws\_route\_table-private\_internal\_subnet-name | n/a |
| aws\_route\_table-private\_subnet-ids | n/a |
| aws\_route\_table-public\_bastion\_subnet-ids | n/a |
| aws\_route\_table-public\_subnet-ids | n/a |
| aws\_vpc\_endpoint-codebuild | n/a |
| aws\_vpc\_endpoint-dynamodb | n/a |
| aws\_vpc\_endpoint-s3 | ################ # VPC Endpoint # ################ |
| bastion-nat-subnet-arn | n/a |
| bastion-nat-subnet-cidrblock | n/a |
| bastion-nat-subnet-id | ##################### Subnet Bastion Nat # ##################### |
| bastion-nat-subnet\_tags-Name | n/a |
| eip\_nat-public\_ip | ################ #     EIPS     # ################ |
| internet\_gateway-main\_gw-id | ################ #     IGW      # ################ |
| internet\_gateway-main\_gw-name | n/a |
| nat\_gateway-nat\_gw-id | ################ #    NAT GW    # ################ |
| nat\_gateway-nat\_gw-name | n/a |
| nat\_gateway-nat\_gw-public\_ip | n/a |
| nat\_gateway-nat\_gw-subnet\_id | n/a |
| private-internal-subnet-arn | n/a |
| private-internal-subnet-cidrblock | n/a |
| private-internal-subnet-id | ########################## Subnet Private Internal # ########################## |
| private-internal-subnet\_tags-Name | n/a |
| private\_lb\_subnet-arn | n/a |
| private\_lb\_subnet-cidrblock | n/a |
| private\_lb\_subnet-id | #################### Subnet Private-lb # #################### |
| private\_lb\_subnet\_tags | n/a |
| private\_subnet-arn | n/a |
| private\_subnet-cidrblock | n/a |
| private\_subnet-id | #################### Subnet Private   # #################### |
| private\_subnet-tags | n/a |
| public\_subnet-arn | n/a |
| public\_subnet-cidrblock | n/a |
| public\_subnet-id | ################ Subnet Public # ################ |
| public\_subnet-tags | n/a |
| vpc\_arn | n/a |
| vpc\_cidr\_block | n/a |
| vpc\_cidr\_name | n/a |
| vpc\_id | ######## VPC  # ######## |
| zone\_id | The hosted zone id |

<<<<<<< HEAD
=======

>>>>>>> networking
