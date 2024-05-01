terraform {
  backend "s3" {
    bucket         = "tofu-state-notifycal-layer-0"
    dynamodb_table = "tofu-lock-notifycal-layer-0"
    encrypt        = true
    key            = "cloudflare/terraform.tfstate"
    region         = "eu-west-1"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
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
