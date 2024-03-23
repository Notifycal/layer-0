resource "github_dependabot_secret" "dependabot_pat" {
  # This is enabled for all repos by default
  for_each = toset(data.github_repositories.all_repos.names)

  repository       = each.value
  secret_name      = "DEPENDABOT_PAT"
  plaintext_value  = var.dependabot_pat
}
