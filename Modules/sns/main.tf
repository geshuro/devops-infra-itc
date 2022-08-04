/**
* ## SNS Module
*
* This module creates an SNS topic and suscribes the emails passed by variable.
* On destroy, unsuscribes the emails (only works for confirmed subscriptions, unconfirmed subscriptions dissapear after 3 days)
*
* ## Requirements
* On Windows, Bash / Shellscript and jq (https://stedolan.github.io/jq/) installed.
* On Linux, jq (https://stedolan.github.io/jq/) installed.
*/

resource "aws_sns_topic" "sns-topic" {
  name = var.sns_topic_name
  tags = var.tags

  provisioner "local-exec" { // On destroy unsusbcribes all confirmed subscriptions
    when    = destroy
    command = "sh ${path.module}/scripts/sns_unsubscribe.sh" # Dependencies: Bash, jq (https://stedolan.github.io/jq/)
    environment = {
      region  = var.region
      profile = var.profile
      sns_arn = self.arn
    }
  }
}

resource "null_resource" "suscriber" {
  triggers = {
    always_run = timestamp() //Always runs on apply
  }
  provisioner "local-exec" { //Checks for emails not susbcribed and susbcribes them
    command = "sh ${path.module}/scripts/sns_subscription.sh" # Dependencies: Bash, jq (https://stedolan.github.io/jq/)
    environment = {
      region     = var.region
      profile    = var.profile
      sns_arn    = aws_sns_topic.sns-topic.arn
      sns_emails = var.sns_subscription_emails
    }
  }
  depends_on = [aws_sns_topic.sns-topic]
}
