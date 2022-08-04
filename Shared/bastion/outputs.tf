output "key_name" {
  value       = module.aws_key_pair.key_name
  description = "Name of SSH key"
}

output "private_key_filename" {
  description = "Private Key Filename"
  value       = module.aws_key_pair.private_key_filename
}

output "ssm_parameter_arn" {
  description = "ARN ssm parameter"
  value       = module.ssm-key-pair.ssm-path-arn
}

output "bastion_sg_id" {
  description = "The ID of the security group"
  value       = module.sg-bastion-ssh.this_security_group_id
}

output "bastion_vpc_id" {
  description = "The VPC ID"
  value       = module.sg-bastion-ssh.this_security_group_vpc_id
}

output "bastion_sg_name" {
  description = "The name of the security group"
  value       = module.sg-bastion-ssh.this_security_group_name
}

output "bastion_launch_config_id" {
  description = "id del launch configuration bastion"
  value       = aws_launch_configuration.bastion.id
}

output "bastion_launch_config_name" {
  description = "Name del launch configuration bastion"
  value       = aws_launch_configuration.bastion.name
}

output "bastion_launch_config_arn" {
  description = "ARN del launch configuration bastion"
  value       = aws_launch_configuration.bastion.arn
}

//output "Subnet-IDS" {
//    value = data.terraform_remote_state.bastion.outputs.nat-subnet-id
//}

output "group-ssh" {
  value = aws_iam_group.ssh.name
}

output "group-ssh-admin" {
  value = aws_iam_group.ssh-admin.name
}

output "eip_bastion" {
  value = aws_eip.eip_bastion.public_ip
}

//output "VPC-CidrBlock" {
//  value = data.terraform_remote_state.bastion.outputs.vpc_cidr_block
//}



# output "user-data" {
#     value = "${data.template_file.user_data.rendered}"
# }