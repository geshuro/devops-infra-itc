## Web Application Firewall (WAF) Module

This module creates a Regional Web ACL with the defult ruleset blocking SQL injection.  
If enabled, associates the Web ACL to an existing API Gateway stage.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| AWS\_PROFILE | AWS profile used to suscribe the emails to the SNS topic | `string` | n/a | yes |
| AWS\_REGION | AWS region where the SNS topic will be created | `string` | n/a | yes |
| associate\_api\_gateway | Associates the created Web ACL to an API Gateway | `bool` | `false` | no |
| rest\_api\_gw\_id | Rest API Gateway id to associate the Web ACL | `string` | `""` | no |
| rest\_api\_gw\_stage\_name | Rest API Gateway stage name to associate the Web ACL | `string` | `""` | no |
| tags | Implements the common\_tags scheme | `map(string)` | n/a | yes |
| web\_acl\_name | Web ACL name | `string` | n/a | yes |

## Outputs

No output.

