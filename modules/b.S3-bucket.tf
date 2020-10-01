resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_buc_name
  acl = "private"
  tags = {
    "Name" = var.s3_buc_name
  }
}
