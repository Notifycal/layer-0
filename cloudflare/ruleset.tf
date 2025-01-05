data "cloudflare_zone" "es_zones" {
  for_each = toset(var.redirect_base_domains)

  name = each.value
}

resource "cloudflare_ruleset" "es_main" {
  for_each = data.cloudflare_zone.es_zones

  zone_id = each.value.id
  name    = "${local.redirect_domains[each.key]}-es-redirect"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"


  dynamic "rules" {
    for_each = merge({ main = local.redirect_domains[each.key] }, var.enable_www_redirect ? { redirect = "www.${local.redirect_domains[each.key]}" } : {})
    content {
      action = "redirect"
      action_parameters {
        from_value {
          status_code = 301
          target_url {
            value = "https://${local.domain}/es/"
          }
          preserve_query_string = true
        }
      }

      expression = "(http.host eq \"${rules.value}\")"
    }
  }
}
