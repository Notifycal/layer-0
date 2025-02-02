## Github App secrets. Required for issue handing stuff
resource "github_actions_secret" "cicd_app_id" {
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "NOTIFYCAL_CICD_APP_ID"
  plaintext_value = data.aws_ssm_parameter.cicd_app_id.value
}

resource "github_actions_secret" "cicd_app_secret" {
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "NOTIFYCAL_CICD_APP_SECRET"
  plaintext_value = data.aws_ssm_parameter.cicd_app_secret.value
}

## Need to create them as dependabot secrets too so dependabot can access them
resource "github_dependabot_secret" "cicd_app_id" {
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "NOTIFYCAL_CICD_APP_ID"
  plaintext_value = data.aws_ssm_parameter.cicd_app_id.value
}

resource "github_dependabot_secret" "cicd_app_secret" {
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "NOTIFYCAL_CICD_APP_SECRET"
  plaintext_value = data.aws_ssm_parameter.cicd_app_secret.value
}

resource "github_dependabot_secret" "dependabot_pat" {
  # This is enabled for all repos by default
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "DEPENDABOT_PAT"
  plaintext_value = var.dependabot_pat
}
