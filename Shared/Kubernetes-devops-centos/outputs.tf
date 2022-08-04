#########
#  EC2  #
#########

output "kubernetes_private_ip" {
  value       = aws_instance.kubernetes_server.*.private_ip
  description = "Private IP for Kubernetes"
}

output "kubernetes_private_dns" {
  value       = aws_route53_record.kubernetes_private_dns.*.name
  description = "Private DNS for Kubernetes"
}

output "server_security_group_id" {
  description = "Security group ID attached to the Cluster Kubernetes"
  #value       = local.server_security_group_id
  value       = aws_security_group.kubernetes_access.*.id
  #value       = aws_security_group.elasticsearch_access.*.id
}
