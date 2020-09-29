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

module "execute_modules" {
  source = "./modules"
}



