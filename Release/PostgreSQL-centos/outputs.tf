#########
#  EC2  #
#########

output "postgresql_private_ip" {
  value       = aws_instance.postgresql_server.*.private_ip
  description = "Private IP for postgresql"
}

output "postgresql_private_dns" {
  value       = aws_route53_record.postgresql_private_dns.*.name
  description = "Private DNS for postgresql"
}

output "server_security_group_id" {
  description = "Security group ID attached to the Cluster postgresql"
  #value       = local.server_security_group_id
  value       = aws_security_group.postgresql_access.*.id
}