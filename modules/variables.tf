
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