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
}

resource "aws_iam_role_policy_attachment" "dynamo-full-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3-read-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" 
}

resource "aws_iam_role_policy_attachment" "lambda-exec-policy-attach" {
  role       = aws_iam_role.s3_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}