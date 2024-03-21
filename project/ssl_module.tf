module "notifycal_ssl" {
  source = "git@github.com:Notifycal/tofu-module-acm-cert.git?ref=v0.1.0"

  for_each = aws_route53_zone.primary

  hosted_zone_name = each.value.name
  domain_name = each.key
  subject_alternative_names = ["www.${each.value.name}"]
}
