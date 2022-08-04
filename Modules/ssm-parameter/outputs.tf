output "ssm-path-arn" {
  value       = aws_ssm_parameter.aws_key_pair.arn
  description = "The ARN of the parameter."
}
output "ssm-path-name" {
  value       = aws_ssm_parameter.aws_key_pair.name
  description = "The name of the parameter."
}