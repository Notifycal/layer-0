terraform {
  backend "s3" {
    bucket         = "tofu-state-global-notifycal-layer-0"
    dynamodb_table = "tofu-lock-global-notifycal-layer-0"
    encrypt        = true
    key            = "cloudflare/terraform.tfstate"
    region         = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "aws_region" {
  type = string
}

variable "project" {
  type = string
}

variable "stack" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  alias  = "nonprod"
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_target_account_ids["nonprod"]}:role/impersonate-from-mgmt"
    session_name = "tofu-layer-0-nonprod"
  }

  default_tags {
    tags = {
      Project    = var.project
      Region     = var.aws_region
      Managed-By = "OpenTofu"
      Stack      = var.stack
    }
  }
}

provider "aws" {
  alias  = "prod"
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_target_account_ids["prod"]}:role/impersonate-from-mgmt"
    session_name = "tofu-layer-0-prod"
  }

  default_tags {
    tags = {
      Project    = var.project
      Region     = var.aws_region
      Managed-By = "OpenTofu"
      Stack      = var.stack
    }
  }
}
