variable "aws_region" {
  type = string
}

variable "project" {
  type = string
}


provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = var.project
      Region = var.aws_region
      Managed-By = "Terragrunt"
    }
  }
}
