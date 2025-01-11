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

resource "github_dependabot_secret" "dependabot_pat" {
  # This is enabled for all repos by default
  for_each = toset(data.github_repositories.all_repos.names)

  repository      = each.value
  secret_name     = "DEPENDABOT_PAT"
  plaintext_value = var.dependabot_pat
}

resource "github_branch_protection" "this" {
  for_each = var.enable_branch_protection ? toset(data.github_repositories.all_repos.names) : []

  repository_id = each.key
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  required_status_checks {
    contexts = []
    strict   = false
  }
}
