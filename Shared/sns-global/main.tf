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

module "sns-global" {
  source                  = "../../Modules/sns"
  sns_topic_name          = var.sns_topic_name
  sns_subscription_emails = var.sns_subscription_emails
  region                  = local.region
  profile                 = local.profile
  tags = {
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

# module "sns-dev" {
#   source                  = "../../Modules/sns"
#   sns_topic_name          = "sns-atos-integracam-dev-alerts"
#   sns_subscription_emails = "isaac.mendoza.external@atos.net isaac.mendoza.external2@atos.net" //Space-separated emails to subscribe
#   AWS_REGION              = "us-east-1"
#   AWS_PROFILE             = "atos-integracam"
#   tags = {
#     company     = "ATOS"
#     project     = "ATOS - INTEGRACAM"
#     terraform   = "true"
#     Environment = "Dev"
#   }
# }

# module "sns-test" {
#   source                  = "../../Modules/sns"
#   sns_topic_name          = "sns-atos-integracam-testing-alerts"
#   sns_subscription_emails = "saac.mendoza.external@atos.net isaac.mendoza.external2@atos.net" //Space-separated emails to subscribe
#   AWS_REGION              = "us-east-1"
#   AWS_PROFILE             = "atos-integracam"
#   tags = {
#     company     = "ATOS"
#     project     = "ATOS - INTEGRACAM"
#     terraform   = "true"
#     Environment = "Test"
#   }
# }