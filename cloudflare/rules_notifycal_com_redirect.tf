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
            # Conserva path; query la preserva el flag
            # expression = "concat(\"https://${label == "@" ? var.main_zone : "${label}.${var.main_zone}"}, http.request.uri.path\")"
            expression = format(
              "concat(\"https://%s\", http.request.uri.path)",
              label == "@" ? var.main_zone : format("%s.%s", label, var.main_zone)
            )

          }
        }
      }
    }
  ]

  # rules = concat([{
  #   enabled     = true
  #   action      = "redirect"
  #   description = "Redirect ${each.value.name} -> ${var.main_zone}"
  #   expression  = "(http.host eq \"${each.value.name}\" or http.host eq \"www.${each.value.name}\")"

  #   action_parameters = {
  #     from_value = {
  #       status_code = 301
  #       preserve_query_string = true
  #       target_url  = {
  #         expression = "concat(\"https://${var.main_zone}\", http.request.uri.path)"
  #       }
  #     }
  #   }
  # }],
  # [
  #     for s in var.subdomains : {
  #       enabled     = true
  #       action      = "redirect"
  #       description = "${s}.${each.value.name} -> ${s}.${var.main_zone}"
  #       expression  = "http.host eq \"${s}.${each.value.name}\""
  #       action_parameters = {
  #         from_value = {
  #           status_code           = 301
  #           preserve_query_string = true
  #           target_url = {
  #             expression = "concat(\"https://${s}.${var.main_zone}\", http.request.uri.path)"
  #           }
  #         }
  #       }
  #     }
  #   ]
}

# "rules": [
#       {
#         "action": "redirect",
#         "action_parameters": {
#           "from_value": {
#             "preserve_query_string": true,
#             "status_code": 301,
#             "target_url": {
#               "expression": "concat(\"https://notifycal.com\", http.request.uri.path)"
#             }
#           }
#         },
#         "description": "Redirect to notifycal.com",
#         "enabled": true,
#         "expression": "(http.host eq \"notifycal.es\")",
#         "id": "2ecfd797f1ed4062b770f4172137e4d1",
#         "last_updated": "2025-09-12T13:24:14.140509Z",
#         "ref": "2ecfd797f1ed4062b770f4172137e4d1",
#         "version": "1"
#       }
#     ],
#     "version": "1"
#   },


# output "foobar" {
#   value = local.extra_records
# }
