######################
# VPC Endpoint for S3
######################
data "aws_vpc_endpoint_service" "s3" {
  count   = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  service = "s3"
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  count        = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  vpc_id       = var.main_vpc
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
  tags         = merge(tomap({Name = "S3-VPCEndpoint"}), var.tags)
}

# #Inicialmente partimos de la premisa del acceso a S3 desde servicios ubicados en las subnets privadas, si no, añadir/cambiar...
resource "aws_vpc_endpoint_route_table_association" "private_s3-za" {
  count           = var.create_vpc && var.enable_s3_endpoint ? 2 : 0
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(var.route-table-private-za, count.index)
}
/* imendoza
resource "aws_vpc_endpoint_route_table_association" "private_s3-zb" {
  count           = var.create_vpc && var.enable_s3_endpoint ? 2 : 0
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(var.route-table-private-zb, count.index)
}
*/
############################
# VPC Endpoint for DynamoDB
############################
data "aws_vpc_endpoint_service" "dynamodb" {
  count   = var.create_vpc && var.enable_dynamodb_endpoint ? 1 : 0
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count        = var.create_vpc && var.enable_dynamodb_endpoint ? 1 : 0
  vpc_id       = var.main_vpc
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  tags         = merge(tomap({Name = "S3-DynamoDBEndpoint"}), var.tags)
}