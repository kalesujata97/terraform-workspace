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
	"Statement": [{
		"Action": "sts:AssumeRole",
		"Principal": {
			"Service": "lambda.amazonaws.com"
		},
		"Effect": "Allow"
	}]
}
	EOF

  tags = {
    "Name" = var.iam_s3_lambda
  }
  depends_on = [aws_s3_bucket.s3_bucket]
}
