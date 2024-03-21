resource "aws_route53_zone" "primary" {
  for_each = var.hosted_zones

  name = each.value
}
