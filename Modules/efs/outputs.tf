output "arn" {
  value       = aws_efs_file_system.efs_arqref.arn
  description = "EFS ARN"
}

output "id" {
  value       = aws_efs_file_system.efs_arqref.id
  description = "EFS ID"
}

output "dns_name" {
  value       = aws_efs_file_system.efs_arqref.dns_name
  description = "EFS DNS name"
}

output "security_group_id" {
  value       = join("",aws_security_group.efs_arqref.*.id)
  description = "EFS Security Group ID"
}

output "security_group_arn" {
  value       = join("",aws_security_group.efs_arqref.*.arn)
  description = "EFS Security Group ARN"
}

output "security_group_name" {
  value       = join("",aws_security_group.efs_arqref.*.name)
  description = "EFS Security Group name"
}

output "mount_target_ids" {
  value       = coalescelist(aws_efs_mount_target.efs_arqref.*.id, [""])
  description = "List of EFS mount target IDs (one per Availability Zone)"
}
