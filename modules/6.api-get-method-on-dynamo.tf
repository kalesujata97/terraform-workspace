resource "aws_api_gateway_method" "get-method" {
   rest_api_id   = aws_api_gateway_rest_api.dynamo-rest-api.id
   resource_id   = aws_api_gateway_resource.resource.id
   http_method   = "GET"
   authorization = "None"
   depends_on = [aws_api_gateway_resource.resource]
}
resource "aws_api_gateway_integration" "dynamo" {
   rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
   resource_id = aws_api_gateway_resource.resource.id
   http_method = aws_api_gateway_method.get-method.http_method

   integration_http_method = "POST"
   type                    = "AWS"
   credentials             = aws_iam_role.api-dynamo-iam-role.arn
   uri                     = "arn:aws:apigateway:us-east-2:dynamodb:action/GetItem"
   
   request_templates = {
	   "application/json" = <<EOF
{
  "TableName": "Employee",
  "Key": {
    "empid": {
      "N": "$input.params('empid')"
    }
  }
}
EOF	   
	}
	depends_on = [aws_api_gateway_resource.resource]	
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get-method.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
         "application/json" = "Empty"
  }
  depends_on = [aws_api_gateway_integration.dynamo]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get-method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }
  response_templates = {
    "application/json" = <<EOF
{
  "empid": "$input.path('$.Item.empid.N')",
  "name": "$input.path('$.Item.name.S')",
  "salary": "$input.path('$.Item.salary.N')"
}
EOF
  }
  depends_on = [aws_api_gateway_integration.dynamo]
}




