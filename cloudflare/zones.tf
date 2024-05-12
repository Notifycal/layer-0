resource "cloudflare_zone" "zones" {
  for_each = var.hosted_zones

  account_id = data.cloudflare_accounts.this.accounts[0].id
  zone       = each.value
}

resource "cloudflare_zone_settings_override" "zone_settings" {
  for_each = cloudflare_zone.zones

  zone_id = each.value.id

  settings {
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    ssl                      = "flexible" # because of the nature of S3

    brotli = "on"
  }
}
