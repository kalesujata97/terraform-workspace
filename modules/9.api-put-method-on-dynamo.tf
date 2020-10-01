resource "aws_api_gateway_method" "put-method" {
   rest_api_id   = aws_api_gateway_rest_api.dynamo-rest-api.id
   resource_id   = aws_api_gateway_resource.resource.id
   http_method   = "PUT"
   authorization = "None"
   depends_on = [aws_api_gateway_resource.resource]
}
resource "aws_api_gateway_integration" "dynamo-put" {
   rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
   resource_id = aws_api_gateway_resource.resource.id
   http_method = aws_api_gateway_method.put-method.http_method

   integration_http_method = "POST"
   type                    = "AWS"
   credentials             = aws_iam_role.api-dynamo-iam-role.arn
   uri                     = "arn:aws:apigateway:us-east-2:dynamodb:action/PutItem"
   
   request_templates = {
	   "application/json" = <<EOF
{
    "TableName": "Employee",
    "Item": {
		"empid": {
            "N": "$input.params('empid')"
        },
    	"name": {
            "S": "$input.path('$.name')"
        },
        "salary": {
            "N": "$input.path('$.salary')"
        }
    }
}
EOF	   
	}
	depends_on = [aws_api_gateway_resource.resource]	
}
resource "aws_api_gateway_deployment" "dynamo-api-deployment" {
  
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  stage_name  = "PutOnDynamo"
  depends_on = [aws_api_gateway_integration.dynamo-put]
}



resource "aws_api_gateway_method_response" "put_response_200" {
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.put-method.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
         "application/json" = "Empty"
  }
  depends_on = [aws_api_gateway_integration.dynamo-put]
}

resource "aws_api_gateway_integration_response" "PutIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.put-method.http_method
  status_code = aws_api_gateway_method_response.put_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }
  depends_on = [aws_api_gateway_integration.dynamo-put]
}

