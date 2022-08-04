data "aws_route53_zone" "r53_zone_arqref" {
  count = var.zone_name == "" ? 0 : 1
  name         = var.zone_name
  private_zone = true
}


resource "aws_route53_record" "writer" {
  count = var.zone_name == "" ? 0 : 1  
  zone_id = join("",data.aws_route53_zone.r53_zone_arqref.*.zone_id)
  name    = "writer-${local.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_elasticache_replication_group.redis_arqref.primary_endpoint_address}"]
}



