module "aws_acm_star_notifycal_ssl_cert" {
  source = "../../tofu-module-acm-cert"

  domain_name = "*.notifycal.com"
  dns_validation_config = {
    vendor = "cloudflare"
    cloudflare = {
      zone_id = cloudflare_zone.zones["notifycal.com"].id
      proxied = false
    }
  }
}
