output "web_acl_id" {
  value = "${aws_wafregional_web_acl.waf_acl.id}"
}