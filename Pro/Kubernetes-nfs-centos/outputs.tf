#########
#  EC2  #
#########

output "private_ip" {
  value       = aws_instance.server.*.private_ip
  description = "Private IP for NFS"
}

output "private_dns" {
  value       = aws_route53_record.private_dns.*.name
  description = "Private DNS for NFS"
}

output "server_security_group_id" {
  description = "Security group ID attached to the NFS"
  value       = aws_security_group.access.*.id
}
