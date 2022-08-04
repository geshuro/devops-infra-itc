data "aws_route53_zone" "r53_zone_arqref" {
  count = var.zone_name == "" ? 0 : 1
  name         = var.zone_name
  private_zone = true
}


resource "aws_route53_record" "writer" {
  count = var.zone_name == "" ? 0 : 1  
  zone_id = join("",data.aws_route53_zone.r53_zone_arqref.*.zone_id)
  name    = "rw-${local.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.aurora_arqref.endpoint}"]
}

resource "aws_route53_record" "reader" {
  count = var.zone_name == "" ? 0 : 1
  zone_id = join("",data.aws_route53_zone.r53_zone_arqref.*.zone_id)
  name    = "ro-${local.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.aurora_arqref.reader_endpoint}"]
}