terraform {
  backend "s3" {
    bucket         = "tofu-state-notifycal-r3h5d3gp"
    dynamodb_table = "tofu-lock-notifycal-r3h5d3gp"
    encrypt        = true
    key            = "auth-service/terraform.tfstate"
    region         = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "project" {
  type = string
  default = "notifycal"
}

variable "stack_name" {
  type = string
  default = "auth-service"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = var.project
      Region = var.aws_region
      Managed-By = "OpenTofu"
      Stack = var.stack_name
    }
  }
}
