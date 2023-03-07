output "ids" {
  description = "List of IDs of instances"
  value       = module.ec2.id
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = module.ec2.public_dns
}

output "vpc_security_group_ids" {
  description = "List of VPC security group ids assigned to the instances"
  value       = module.ec2.vpc_security_group_ids
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sg_this.id
}

output "root_block_device_volume_ids" {
  description = "List of volume IDs of root block devices of instances"
  value       = module.ec2.root_block_device_volume_ids
}

output "ebs_block_device_volume_ids" {
  description = "List of volume IDs of EBS block devices of instances"
  value       = module.ec2.ebs_block_device_volume_ids
}

output "tags" {
  description = "List of tags"
  value       = module.ec2.tags
}

output "placement_group" {
  description = "List of placement group"
  value       = module.ec2.placement_group
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.id[0]
}

output "instance_public_dns" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = module.ec2.public_dns[0]
}

output "instance_private_ip" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = module.ec2.private_ip[0]
}

output "instance_private_dns" {
  description = "Private DNS name assigned to the EC2 instance"
  value       = "${var.stage}-${var.name}.${data.terraform_remote_state.networking.outputs.internal_service_domain}"
}

output "credit_specification" {
  description = "Credit specification of EC2 instance (empty list for not t2 instance types)"
  value       = module.ec2.credit_specification
}