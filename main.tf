terraform {
  backend "remote" {
    organization = "terraform-practice-workspace"

    workspaces {
      name = "terraform-workspace"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_buc_name
  acl = "private"
  tags = {
    "Name" = var.s3_buc_name
  }
}
resource "aws_iam_role" "s3_lambda_iam_role" {
  name = var.iam_s3_lambda
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Action": "sts:AssumeRole",
	  "Principal": {
		"Service": "lambda.amazonaws.com"
	  },
	  "Effect": "Allow"
	}
  ]
}
EOF

  tags = {
    "Name" = var.iam_s3_lambda
  }
  depends_on = [aws_s3_bucket.s3_bucket]
}

resource "aws_iam_role_policy_attachment" "dynamo-full-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  depends_on = [aws_iam_role.s3_lambda_iam_role]
}
resource "aws_iam_role_policy_attachment" "s3-read-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  depends_on = [aws_iam_role.s3_lambda_iam_role]
}
resource "aws_iam_role_policy_attachment" "lambda-exec-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  depends_on = [aws_iam_role.s3_lambda_iam_role]
} 

resource "aws_lambda_function" "s3_lambda_trigger" {
  filename      = "lambda_function.zip"
  function_name = "handler"
  role          = aws_iam_role.s3_lambda_iam_role.arn
  handler       = "handler.py"

  #source_code_hash = filebase64sha256("lambda_function.zip")

  runtime = "python3.8"
  
  depends_on = [aws_iam_role_policy_attachment.lambda-exec-policy-attach]
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_bucket.arn
  
  depends_on = [aws_lambda_function.s3_lambda_trigger]
} 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda_trigger.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_function.s3_lambda_trigger]
}
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamo_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "empid"
  
  attribute {
    name = "empid"
    type = "N"
  } 
  depends_on = [aws_s3_bucket_notification.bucket_notification]  
}

