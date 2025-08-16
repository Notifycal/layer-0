// Docs: check out verification status at https://search.google.com/search-console
// Process: log into Google Search Console with notifycal gmail account , add the domain, copy the verification code and paste it here
locals {
  google_verification_codes = {
    "notifycal.es"  = "14FoPvE9vFflBaPv71cyscFwPMESncxsNcqrYmpcYjU"
    "notifycal.com" = "UKRbgqrTY9AqnBdDJp_bITd5QDb68eQfyx7mzn3CApU"
    "notifical.es"  = "PFdykXSS_8EZPNxcJzGpN_DtgadeDHOHU-JDfIH4Puc"
  }
}

resource "cloudflare_record" "google_domain_verification" {
  for_each = local.google_verification_codes

  zone_id = cloudflare_zone.zones[each.key].id
  name    = each.key
  type    = "TXT"
  content = "google-site-verification=${each.value}"
  ttl     = 300
  comment = "Google domain verification for ${each.key}"
}
