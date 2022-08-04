# ################
# # VPC Endpoint #
# ################
output "aws_vpc_endpoint-s3" {
  value = aws_vpc_endpoint.s3.*.service_name
}
output "aws_vpc_endpoint-dynamodb" {
  value = aws_vpc_endpoint.dynamodb.*.service_name
}