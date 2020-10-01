resource "aws_api_gateway_deployment" "dynamo-api-deployment" {
  
  rest_api_id = aws_api_gateway_rest_api.dynamo-rest-api.id
  stage_name  = "default"
  depends_on = [aws_api_gateway_integration.dynamo-put]
}

output "deployment-url" {
  value = "${aws_api_gateway_deployment.dynamo-api-deployment.invoke_url}"
}
