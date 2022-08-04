## SNS Module Example

This example creates an SNS topic and suscribes the emails passed by variable.  
On destroy, unsuscribes the emails (only works for confirmed subscriptions, unconfirmed subscriptions dissapear after 3 days)

## Requirements  
On Windows, Bash / Shellscript and jq (https://stedolan.github.io/jq/) installed.  
On Linux, jq (https://stedolan.github.io/jq/) installed.

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Providers

No provider.

## Inputs

No input.

## Outputs

No output.

