module "aws_acm_star_notifycal_ssl_cert_nonprod" {
  source = "git@github.com:Notifycal/tofu-module-acm-cert.git?ref=v1.0.0"

  providers = {
    aws = aws.nonprod
  }

  domain_name = "*.notifycal.com"
  dns_validation_config = {
    vendor = "cloudflare"
    ttl    = 1
    cloudflare = {
      zone_id = cloudflare_zone.zones["notifycal.com"].id
      proxied = false
    }
  }
}


module "aws_acm_star_notifycal_ssl_cert_prod" {
  source = "git@github.com:Notifycal/tofu-module-acm-cert.git?ref=v1.0.0"

  providers = {
    aws = aws.prod
  }

  domain_name = "*.notifycal.com"
  dns_validation_config = {
    vendor = "cloudflare"
    ttl    = 1
    cloudflare = {
      zone_id = cloudflare_zone.zones["notifycal.com"].id
      proxied = false
    }
  }
}
