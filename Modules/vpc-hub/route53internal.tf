data "local_file" "updateTime" {
  filename = "updateTime.txt"
}

resource "null_resource" "updateResource" {
  triggers = {
    always_run = timestamp() //Always runs on apply
  }
}

resource "aws_route53_zone" "main" {
  count      = (var.CreateRoute53 == "true" ? 1 : 0)
  depends_on = [null_resource.updateResource]
  name = var.Route53name
  vpc {
    vpc_id = aws_vpc.main.id
  }
  force_destroy = var.force_destroy
  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags, vpc
    ]
  }
}

resource "aws_vpc_dhcp_options" "dnsDomainInternal" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name = var.Route53name
  tags = merge(tomap({Name = "dhcp-${var.vpcName}-${random_string.random.result}"}), var.tags)
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dnsDomainInternal.id
}

resource "aws_route53_zone_association" "secondary" {
  count   = (var.CreateRoute53 == "false" ? 1 : 0)
  zone_id = var.InternalZoneId
  vpc_id  = aws_vpc.main.id
}