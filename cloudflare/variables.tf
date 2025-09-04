variable "cloudflare_api_token" {
  sensitive = true
  type      = string
}

variable "hosted_zones" {
  type = set(string)
}

variable "aws_target_account_ids" {
  type = map(string)
  default = {
    nonprod = "381492094204"
    prod    = "222261726252"
  }
}
