#########
#  EC2  #
#########

output "public_ip" {
  value       = aws_instance.server.*.public_ip
  description = "Public IP for NFS"
}

output "public_dns" {
  value       = aws_instance.server.*.public_dns
  description = "Public DNS for Loadbalancer"
}

output "private_dns" {
  value       = aws_route53_record.private_dns.*.name
  description = "Private DNS for Loadbalancer"
}

output "server_security_group_id" {
  description = "Security group ID attached to the Loadbalancer"
  value       = aws_security_group.access.*.id
}
