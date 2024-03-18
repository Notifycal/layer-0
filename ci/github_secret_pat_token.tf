resource "github_actions_secret" "dependabot_pat" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "DEPENDABOT_PAT"
  plaintext_value  = var.dependabot_pat
}
