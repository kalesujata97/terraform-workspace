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

resource "aws_s3_bucket" "example" {
  bucket = var.s3_buc_name
  acl = "private"
  tags {
    Name = var.s3_buc_name
  }

}