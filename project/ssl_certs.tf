# resource "aws_acm_certificate" "certificate" {
#   # provider = aws.acm

#   for_each = var.hosted_zones

#   domain_name       = format("*.%s", each.value)
#   subject_alternative_names = ["www.${each.value}"]
#   validation_method = "DNS"
# }

# # resource "aws_route53_record" "cert_validation_record" {
# #   for_each = {
# #     for zone, cert in aws_acm_certificate.certificate: zone => [
# #       for dvo in cert.domain_validation_options: {
# #         name   = dvo.resource_record_name
# #         record = dvo.resource_record_value
# #         type   = dvo.resource_record_type
# #         zone_id = aws_route53_zone.primary[zone].id
# #       }
# #     ]
# #   }

# #   allow_overwrite = true
# #   name            = each.value.name
# #   records         = [each.value.record]
# #   ttl             = 60
# #   type            = each.value.type
# #   zone_id         = each.value.zone_id
# # }

# # resource "aws_acm_certificate_validation" "validation" {
# #   # provider = aws.acm
  
# #   for_each = aws_acm_certificate.certificate.arn

# #   certificate_arn         = "${aws_acm_certificate.certificate[each.key].arn}"
# #   validation_record_fqdns = ["${aws_route53_record.environment_validation.fqdn}"]
# # }
