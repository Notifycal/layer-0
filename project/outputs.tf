output nameservers {
  description = "Use these nameservers for your Domain registrar"
  value = { for zone, details in aws_route53_zone.primary: zone => details.name_servers }
}

# output testa {
#   value       = jsonencode(module.notifycal_ssl["notifycal.es"].testa)
# }


# output dipesta {
#   value = {
#     for zone, cert in aws_acm_certificate.certificate: zone => [
#       for dvo in cert.domain_validation_options: merge(dvo, {
#         zone_id = aws_route53_zone.primary[zone].id
#       })
#     ]
#   }
# }

# output dipest22a {
#   value = {
#     for zone, cert in aws_acm_certificate.certificate: zone => [
#       for dvo in cert.domain_validation_options: {
#         name   = dvo.resource_record_name
#         record = dvo.resource_record_value
#         type   = dvo.resource_record_type
#         zone_id = aws_route53_zone.primary[zone].id
#       }
#     ]
#   }
# }
# output dipaaesta {
#   value = {
#     for zone, cert in aws_acm_certificate.certificate: zone => merge(cert.domain_validation_options, {
#       zone_id = aws_route53_zone.primary[zone].id
#     }) 
#   }
# }

# output testa {
#   value = {
#     for dvo in aws_acm_certificate.certificate[*].domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
# }


