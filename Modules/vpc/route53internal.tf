data "local_file" "updateTime" {
  filename = "updateTime.txt"
}

resource "null_resource" "updateResource" {
  triggers = {
    always_run = timestamp() //Always runs on apply
  }
}
  
  #provisioner "local-exec" {
    #command    = "echo date --utc +%s > updateTime.txt" #linuxversion  
    #command     = "(New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date)).TotalSeconds > updateTime.txt" #winversion
    #interpreter = ["PowerShell", "-Command"]

    #on_failure = "continue"
  #}
  #lifecycle {
  #  prevent_destroy = false
    #TODO: IgnoreChanges
  #}
#}

resource "aws_route53_zone" "main" {
  count      = (var.CreateRoute53 == "true" ? 1 : 0)
  depends_on = [null_resource.updateResource]
  name = var.Route53name
  vpc {
    vpc_id = aws_vpc.main.id
  }
  force_destroy = var.force_destroy
  #tags          = merge(map("updateResource", chomp(filebase64(data.local_file.updateTime.filename))), var.tags)
  #tags = merge(map("updateResource", null_resource.updateResource.always_run, var.tags)
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }
}

resource "aws_vpc_dhcp_options" "dnsDomainInternal" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name = var.Route53name
  tags = merge(map("Name", "dhcp-${var.vpcName}-${random_string.random.result}"), var.tags)
}

# resource "aws_vpc_dhcp_options" "dnsDomainInternal" {
#   #domain_name_servers = aws_route53_zone.main.name_servers
#   domain_name = var.Route53name
# }

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dnsDomainInternal.id
}

resource "aws_route53_zone_association" "secondary" {
  #count   = (var.CreateRoute53 == "false" ? 0 : 1)
  zone_id = var.InternalZoneId
  vpc_id  = aws_vpc.main.id
  # lifecycle {
  #   prevent_destroy = false
  #   #TODO: IgnoreChanges
  #   ignore_changes = [
  #     # Ignore changes to tags, e.g. because a management agent
  #     # updates these based on some ruleset managed elsewhere.
  #     vpc
  #   ]
  # }
}