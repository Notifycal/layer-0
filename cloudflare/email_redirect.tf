# References:
# https://juri.dev/notes/email-routing-gmail-cloudflare/
# https://gist.github.com/irazasyed/a5ca450f1b1b8a01e092b74866e9b2f1

locals {
  mx_records = {
    "route1.mx.cloudflare.net" : {
      priority = 20
    }
    "route2.mx.cloudflare.net" : {
      priority = 96
    }
    "route3.mx.cloudflare.net" : {
      priority = 75
    }
  }
  txt_includes = [
    "_spf.mx.cloudflare.net",
    "_spf.google.com"
  ]
  # The addresses here need to be enabled in Gmail settings too
  # Settings > See all settings > Accounts and Import > Send mail as
  email_addresses = [
    "info", "admin", "terminos", "soporte", "baja", "privacidad", "terms", "support", "unsubscribe", "privacy"
  ]
}

resource "cloudflare_record" "email_mx" {
  for_each = local.mx_records

  zone_id  = cloudflare_zone.zones["notifycal.com"].id
  name     = "@"
  content  = each.key
  priority = each.value.priority
  type     = "MX"
}

resource "cloudflare_record" "email_txt" {
  zone_id = cloudflare_zone.zones["notifycal.com"].id
  name    = "@"
  # Double quoting otherwise Cloudflare complains in the UI
  content = "\"v=spf1 ${join(" ", formatlist("include:%s", local.txt_includes))} ~all\""
  type    = "TXT"
}

resource "cloudflare_email_routing_settings" "notifycal_com" {
  zone_id = cloudflare_zone.zones["notifycal.com"].id
  enabled = "true"
}

# Redirect each address to notifycal@gmail.com
resource "cloudflare_email_routing_rule" "notifycal_com" {
  for_each = toset(formatlist("%s@notifycal.com", local.email_addresses))

  zone_id = cloudflare_zone.zones["notifycal.com"].id
  name    = each.key
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = each.value
  }

  action {
    type  = "forward"
    value = ["notifycal@gmail.com"]
  }
}
