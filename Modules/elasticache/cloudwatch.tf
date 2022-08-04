
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.redis_clusters

  alarm_name          = "CPU_utilization_too_high-${local.name}-${count.index + 1}"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "600"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis_arqref.id}-00${count.index + 1}"
  }

  alarm_actions = var.sns_topic_arn_alarm
  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.redis_clusters

  alarm_name          = "FreeableMemory_too_low-${local.name}-${count.index + 1}"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "600"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis_arqref.id}-00${count.index + 1}"
  }

  alarm_actions = var.sns_topic_arn_alarm
  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

resource "aws_cloudwatch_metric_alarm" "cache_evictions" {
  count = var.redis_clusters

  alarm_name          = "Evictions_too_high-${local.name}-${count.index + 1}"
  alarm_description   = "Redis cluster Evictions too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = "600"
  statistic           = "Average"

  threshold = var.alarm_evictions_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis_arqref.id}-00${count.index + 1}"
  }

  alarm_actions = var.sns_topic_arn_alarm

  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}
resource "aws_cloudwatch_metric_alarm" "cache_replication_lag" {
  count = var.redis_clusters

  alarm_name          = "Replication_Lag__too_high-${local.name}-${count.index + 1}"
  alarm_description   = "Redis cluster Evictions too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReplicationLag"
  namespace           = "AWS/ElastiCache"
  period              = "600"
  statistic           = "Average"

  threshold = var.alarm_replication_lag_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis_arqref.id}-00${count.index + 1}"
  }

  alarm_actions = var.sns_topic_arn_alarm

  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })

}

# resource "aws_cloudwatch_metric_alarm" "cache_credid_cpu_balance" {
#   count = substr(var.redis_node_type,0,1) == "t" ? var.redis_clusters : 0 

#   alarm_name          = "CPU_Credil_Balance_too_low-${local.name}-${count.index + 1}"
#   alarm_description   = "Redis cluster CPU utilization"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ElastiCache"
#   period              = "600"
#   statistic           = "Average"

#   threshold = var.alarm_cpu_threshold

#   dimensions = {
#     CacheClusterId = "${aws_elasticache_replication_group.redis_arqref.id}-00${count.index + 1}"
#   }

#   alarm_actions = var.sns_topic_arn_alarm
#   tags = merge(var.tags, {
#     Name = "cwalarm-${local.name}-${count.index + 1}"
#   })
# }
