## SNS Module

This module creates an SNS topic and suscribes the emails passed by variable.  
On destroy, unsuscribes the emails (only works for confirmed subscriptions, unconfirmed subscriptions dissapear after 3 days)

## Requirements  
On Windows, Bash / Shellscript and jq (https://stedolan.github.io/jq/) installed.  
On Linux, jq (https://stedolan.github.io/jq/) installed.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| AWS\_PROFILE | AWS profile used to suscribe the emails to the SNS topic | `string` | n/a | yes |
| AWS\_REGION | AWS region where the SNS topic will be created | `string` | n/a | yes |
| sns\_subscription\_emails | Email list of suscribers (space separated) | `string` | `""` | no |
| sns\_topic\_name | SNS topic name | `string` | n/a | yes |
| tags | Implements the common\_tags scheme | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sns\_topic\_arn | n/a |

