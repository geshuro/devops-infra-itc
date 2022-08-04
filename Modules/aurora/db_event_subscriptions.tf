
##### DB Events Subcriptions #####################

# resource "aws_sns_topic" "sns_aurora_arqref" {
#   name = "sns-${local.name}"
#   tags = merge(var.tags, {
#     Name = "sns-${local.name}"
#   })

# }

resource "aws_db_event_subscription" "db_event_subscription_aurora" {
  name      = "rds-event-${local.name}"
  sns_topic = join("",var.sns_topic_arn_alarm)

  source_type = "db-cluster"
  source_ids  = ["${aws_rds_cluster.aurora_arqref.id}"]

  event_categories = [
    "failover",
    "failure",
    "notification"
  ]
  tags = merge(var.tags, {
    Name = "rds-event-${local.name}"
  })
}