locals {
  blocked_continents = {
    africa    = "AF"
    antartica = "AN"
    asia      = "AS"
    oceania   = "OC"
    tor       = "T1"
  }
  blocked_continents_rule_query = "(ip.src.continent in {${join(" ", formatlist("\"%s\"", values(local.blocked_continents)))}})"
}

resource "cloudflare_ruleset" "continent_block" {
  for_each = cloudflare_zone.zones

  zone_id = each.value.id
  name    = "ruleset"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [{
    enabled     = true
    action      = "block"
    description = "BlockContinentAccess"
    expression  = local.blocked_continents_rule_query
  }]
}
