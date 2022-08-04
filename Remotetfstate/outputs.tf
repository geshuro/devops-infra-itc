output "s3_bucket_id" {
  value       = aws_s3_bucket.terraform-state-storage-s3.id
  description = "The ARN of the S3 bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform-state-storage-s3.arn
  description = "The ARN of the S3 bucket"
}
output "s3_bucket_domain_name" {
  value       = aws_s3_bucket.terraform-state-storage-s3.bucket_domain_name
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name_arn" {
  value       = aws_dynamodb_table.terraform-locks.arn
  description = "The name of the DynamoDB table"
}

output "dynamodb_table_name_id" {
  value       = aws_dynamodb_table.terraform-locks.id
  description = "The name of the DynamoDB table"
}