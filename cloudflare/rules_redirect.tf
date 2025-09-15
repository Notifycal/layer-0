locals {
  subdomains = ["@", "private"]

  extra_records = {
    for item in flatten([
      for z in cloudflare_zone.zones : [
        for label in local.subdomains : flatten([
          label == "@" ? [
            # www dns only for landing, +1 subdomains aren't supported by cloudflare free plan
            {
              key     = "${z.name}:www.${label}"
              zone_id = z.id
              name    = label == "@" ? "www.${z.name}" : "www.${label}.${z.name}"
              target  = label == "@" ? var.main_zone : "${label}.${var.main_zone}"
            }
          ] : [],
          z.name != var.main_zone ? [
            # .es -> .com only for secondary (non main) zones
            {
              key     = "${z.name}:${label}"
              zone_id = z.id
              name    = label == "@" ? z.name : "${label}.${z.name}"
              target  = label == "@" ? var.main_zone : "${label}.${var.main_zone}"
            }
          ] : []
        ])
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

resource "cloudflare_ruleset" "all_redirects" {
  for_each = cloudflare_zone.zones

  zone_id = each.value.id
  name    = "Redirect to ${var.main_zone}"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = concat(
    [
      # www rules only for landing, no private area
      for label in local.subdomains : {
        enabled = true
        action  = "redirect"
        description = format(
          "Redirect www.%s -> %s",
          label == "@" ? each.value.name : format("%s.%s", label, each.value.name),
          label == "@" ? each.value.name : format("%s.%s", label, each.value.name)
        )
        expression = format(
          "http.host eq \"www.%s\"",
          label == "@" ? each.value.name : format("%s.%s", label, each.value.name)
        )
        action_parameters = {
          from_value = {
            status_code           = 301
            preserve_query_string = true
            target_url = {
              expression = format(
                "concat(\"https://%s\", http.request.uri.path)",
                label == "@" ? each.value.name : format("%s.%s", label, each.value.name)
              )
            }
          }
        }
      } if label == "@"
    ],
    [
      # .es -> .com rules only in secondary (non-main) zones
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
      } if each.key != var.main_zone
    ],
  )
}
