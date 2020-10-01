resource "aws_lambda_function" "s3_lambda_trigger" {
  filename      = "my-function.zip"
  function_name = var.lambda_func_name
  role          = aws_iam_role.s3_lambda_iam_role.arn
  handler       = "my-function.lambda_handler"

  runtime = "python3.8"  
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_bucket.arn
  
}
 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda_trigger.arn
    events              = ["s3:ObjectCreated:*"]
  }
}