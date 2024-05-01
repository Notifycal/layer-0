variable "cloudflare_api_token" {
  sensitive = true
  type = string
}

variable "cloudflare_account_id" {
  type = string
}

variable "hosted_zones" {
  type = set(string)
}
