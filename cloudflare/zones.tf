resource "cloudflare_zone" "zones" {
  for_each = var.hosted_zones

  account = {
    id = data.cloudflare_accounts.this.result[0].id
  }
  name = each.value
}

locals {
  zone_settings = {
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    ssl                      = "flexible"
    brotli                   = "on"
  }

  flat_zone_settings = merge([
    for zone_key, zone in cloudflare_zone.zones : {
      for setting_key, setting_value in local.zone_settings :
      "${zone_key}__${setting_key}" => {
        zone_id = zone.id
        setting = setting_key
        value   = setting_value
      }
    }
  ]...)
}

resource "cloudflare_zone_setting" "zone_settings" {
  for_each = local.flat_zone_settings

  zone_id    = each.value.zone_id
  setting_id = each.value.setting
  value      = each.value.value
}
