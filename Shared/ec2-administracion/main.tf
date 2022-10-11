module "stop_ec2_instances" {
  source              = "../../Modules/aws-lambda-auto-start-stop-ec2-instances"
  name                = "StopEc2Instances"
  schedule_expression = "cron(0 20 ? * MON-FRI *)"
  action              = "stop"
  tags                = { "custom:tag" : "someValue" }
  lookup_resource_tag = {
    key   = "Auto-Stop"
    value = true
  }
}

module "start_ec2_instances" {
  source              = "../../Modules/aws-lambda-auto-start-stop-ec2-instances"
  name                = "StartEc2Instances"
  schedule_expression = "cron(55 5 ? * MON-FRI *)"
  action              = "start"
  tags                = { "custom:tag" : "someValue" }
  lookup_resource_tag = {
    key   = "Auto-Start"
    value = true
  }
}

