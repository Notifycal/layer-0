output nameservers {
  description = "Use these nameservers for your Domain registrar"
  value = { for zone, details in aws_route53_zone.primary: zone => details.name_servers }
}
