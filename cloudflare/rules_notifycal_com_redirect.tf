locals {
  secondary_zones = { for k, v in cloudflare_zone.zones : k => v if k != var.main_zone }

  subdomains = ["@", "private"]

  extra_records = {
    for item in flatten([
      for z in local.secondary_zones : [
        for label in local.subdomains : {
          key     = "${z.name}:${label}"
          zone_id = z.id
          name    = label == "@" ? z.name : "${label}.${z.name}"
          target  = label == "@" ? var.main_zone : "${label}.${var.main_zone}"
        }
      ]
      ]) : item.key => {
      zone_id = item.zone_id
      name    = item.name
      target  = item.target
    }
  }
}

resource "cloudflare_dns_record" "extra_domains_redirect" {
  for_each = local.extra_records

  zone_id = each.value.zone_id
  name    = each.value.name
  content = each.value.target
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_ruleset" "redirect_to_notifycal_com" {
  for_each = local.secondary_zones

  zone_id = each.value.id
  name    = "Redirect to ${var.main_zone}"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = [
    for label in local.subdomains : {
      enabled = true
      action  = "redirect"
      description = format(
        "Redirect %s -> %s",
        label == "@" ? each.value.name : format("%s.%s", label, each.value.name),
        label == "@" ? var.main_zone : format("%s.%s", label, var.main_zone)
      )
      expression = format(
        "http.host eq \"%s\"",
        label == "@" ? each.value.name : format("%s.%s", label, each.value.name)
      )
      action_parameters = {
        from_value = {
          status_code           = 301
          preserve_query_string = true
          target_url = {
            expression = format(
              "concat(\"https://%s\", http.request.uri.path)",
              label == "@" ? var.main_zone : format("%s.%s", label, var.main_zone)
            )

          }
        }
      }
    }
  ]
}
