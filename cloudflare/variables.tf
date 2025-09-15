variable "cloudflare_api_token" {
  sensitive = true
  type      = string
}

variable "main_zone" {
  type        = string
  description = "Main zone/domain of the app"
}

variable "hosted_zones" {
  type = set(string)
}

variable "aws_target_account_ids" {
  type = object({
    nonprod = string
    prod    = string
  })
  default = {
    nonprod = "381492094204"
    prod    = "222261726252"
  }
}
