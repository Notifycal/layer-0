module "aws_acm_star_notifycal_ssl_cert" {
  source = "git@github.com:Notifycal/tofu-module-acm-cert.git?ref=v0.2.0"

  domain_name = "*.notifycal.com"

  create_dns_validation_records = false
}

resource "cloudflare_record" "dns_validate" {
  for_each = module.aws_acm_star_notifycal_ssl_cert.certificate_validation_dns_records

  zone_id = cloudflare_zone.zones["notifycal.com"].id

  name    = each.value.name
  content = each.value.record
  type    = each.value.type
  proxied = false
}
