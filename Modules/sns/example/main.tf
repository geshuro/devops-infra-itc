/**
* ## SNS Module Example
*
* This example creates an SNS topic and suscribes the emails passed by variable.
* On destroy, unsuscribes the emails (only works for confirmed subscriptions, unconfirmed subscriptions dissapear after 3 days)
*
* ## Requirements
* On Windows, Bash / Shellscript and jq (https://stedolan.github.io/jq/) installed.
* On Linux, jq (https://stedolan.github.io/jq/) installed.
*/

module "sns" {
  source                  = "../"
  sns_topic_name          = "example_topic"
  sns_subscription_emails = "isaac.mendoza.external@atos.net" //Space-separated emails to subscribe
  AWS_REGION              = "eu-west-1"
  AWS_PROFILE             = "atos-arqref"
  tags = {
    company     = "Atos"
    project     = "Arquitecturas de Referencia - APIGW - Servicios"
    terraform   = "true"
    Environment = "pro"
    CostCenter  = ""
    ServiceId   = ""
    ProjectId   = ""
  }
}