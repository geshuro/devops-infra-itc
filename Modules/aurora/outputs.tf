// aws_rds_cluster
output "aurora_arqref_rds_cluster_arn" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.aurora_arqref.arn
}

output "aurora_arqref_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.aurora_arqref.id
}

output "aurora_arqref_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = aws_rds_cluster.aurora_arqref.cluster_resource_id
}

output "aurora_arqref_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora_arqref.endpoint
}

output "aurora_arqref_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.aurora_arqref.reader_endpoint
}

// database_name is not set on `aws_rds_cluster` resource if it was not specified, so can't be used in output
output "aurora_arqref_rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = var.database_name
}

output "aurora_arqref_rds_cluster_master_password" {
  description = "The master password"
  value       = aws_rds_cluster.aurora_arqref.master_password
  sensitive   = true
}

output "aurora_arqref_rds_cluster_port" {
  description = "The port"
  value       = aws_rds_cluster.aurora_arqref.port
}

output "aurora_arqref_rds_cluster_master_username" {
  description = "The master username"
  value       = aws_rds_cluster.aurora_arqref.master_username
}

// aws_rds_cluster_instance
output "aurora_arqref_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = aws_rds_cluster_instance.aurora_arqref.*.endpoint
}

// aws_security_group
output "aurora_arqref_security_group_id" {
  description = "The security group ID of the cluster"
  value       = local.rds_security_group_id
}

output "dns_name_cluster" {
  value = join("",aws_route53_record.writer.*.name,["."],["${var.zone_name}"])
}

output "dns_name_cluster_reader" {
  value = join("",aws_route53_record.reader.*.name,["."],["${var.zone_name}"])
}
