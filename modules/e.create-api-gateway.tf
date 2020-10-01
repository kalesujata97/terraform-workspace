
resource "aws_api_gateway_rest_api" "dynamo-rest-api" {
  name = var.api_gateway_name
  description = "This API is for performing CRUD on DynamoDB table"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "resource" {
   rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
   parent_id   = aws_api_gateway_rest_api.dynamo-rest-api.root_resource_id
   path_part   = "{empid}"
   depends_on = [aws_api_gateway_rest_api.dynamo-rest-api]
}

