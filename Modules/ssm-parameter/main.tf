resource "aws_ssm_parameter" "aws_key_pair" {
  name        = var.name
  description = var.description
  type        = var.type
  value       = var.value
  tags        = var.tags
}