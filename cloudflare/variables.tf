variable "cloudflare_api_token" {
  sensitive = true
  type      = string
}

variable "hosted_zones" {
  type = set(string)
}
