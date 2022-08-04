resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count = var.replica_count 
  
  alarm_name          = "cpu_utilization_too_high-${local.name}-${count.index + 1}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = var.sns_topic_arn_alarm
  ok_actions          = var.sns_topic_arn_alarm
  dimensions = {
    DBInstanceIdentifier = "${local.name}-${count.index + 1}"
  }
  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  count = substr(var.instance_type,0,1) == "t" ? var.replica_count : 0   
  alarm_name          = "cpu_credit_balance_too_low-${local.name}-${count.index + 1}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.cpu_credit_balance_threshold
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = var.sns_topic_arn_alarm
  ok_actions          = var.sns_topic_arn_alarm

  dimensions = {
    DBInstanceIdentifier = "${local.name}-${count.index + 1}"
  }
  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  count = var.replica_count   
  alarm_name          = "freeable_memory_too_low-${local.name}-${count.index + 1}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.freeable_memory_threshold
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = var.sns_topic_arn_alarm
  ok_actions          = var.sns_topic_arn_alarm

  dimensions = {
    DBInstanceIdentifier = "${local.name}-${count.index + 1}"
  }
  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  count = var.replica_count  
  
  alarm_name          = "free_local_storage_space_threshold-${local.name}-${count.index + 1}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.free_storage_space_threshold
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = var.sns_topic_arn_alarm
  ok_actions          = var.sns_topic_arn_alarm

  dimensions = {
    DBInstanceIdentifier = "${local.name}-${count.index + 1}"
  }

  tags = merge(var.tags, {
    Name = "cwalarm-${local.name}-${count.index + 1}"
  })
}

