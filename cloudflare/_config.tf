terraform {
  backend "s3" {
    bucket         = "tofu-state-notifycal-layer-0"
    dynamodb_table = "tofu-lock-notifycal-layer-0"
    encrypt        = true
    key            = "cloudflare/terraform.tfstate"
    region         = "eu-west-1"
  }

  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# variable "aws_region" {
#   type = string
# }

variable "project" {
  type = string
}

variable "stack" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# provider "aws" {
#   region = var.aws_region

#   default_tags {
#     tags = {
#       Project = var.project
#       Region = var.aws_region
#       Managed-By = "OpenTofu"
#       Stack = var.stack
#     }
#   }
# }
