variable "s3_buc_name" {
    type = string
    default = "s3-lambda-trigger-example"
}

variable "iam_s3_lambda" {
    type = string
    default = "s3-lambda-trigger-iam-role"
}
variable "lambda_func_name" {
    type = string
    default = "s3-lambda-trigger_function"
}
variable "dynamo_table_name" {
    type = string
    default = "Employee"
}

variable "api_dynamo_iam_role_name" {
    type = string
    default = "APIDynamoIAMRole"
}

variable "api_gateway_name" {
    type = string
    default = "DynamoAPI"
}
