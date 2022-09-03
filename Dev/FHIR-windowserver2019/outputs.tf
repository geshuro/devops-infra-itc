#########
#  EC2  #
#########

output "fhir_private_ip" {
  value       = aws_instance.fhir.*.private_ip
  description = "Private IP for fhir"
}

output "fhir_private_dns" {
  value       = aws_route53_record.fhir_dns.*.name
  description = "Private DNS for fhir"
}

output "server_security_group_id" {
  description = "Security group ID attached to the server windows fhir"
  value       = aws_security_group.fhir_access.*.id
}

output "administrator_password" {
   value = [
     for g in aws_instance.fhir : rsadecrypt(g.password_data,file("${module.aws_key_pair.private_key_filename}"))
   ]
}