data "aws_ssm_parameter" "cicd_app_id" {
  name = "/providers/github/app/notifycal-ci-cd/app_id"
}

data "aws_ssm_parameter" "cicd_app_secret" {
  name = "/providers/github/app/notifycal-ci-cd/app_secret"
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "/providers/cloudflare/api_token"
}

locals {
  # this array can be used to do partial matches too. ie: `tofu-module-`
  include_repos = [
    "docs-internal",
    "^environments$" # strict match to avoid picking poc-environments
    # infra repo goes here
  ]

  # Keep repos that match any regex in local.include_repos
  repos = toset([
    for repo in data.github_repositories.all_repos.names : repo if anytrue([
      for included_repo in local.include_repos : length(regexall(included_repo, repo)) > 0
    ])
  ])
}

## AWS IAM role name for CI/CD
resource "github_actions_secret" "iam_role_for_ci" {
  for_each = local.repos

  repository      = each.value
  secret_name     = "AWS_IAM_ROLE_CI"
  plaintext_value = aws_iam_role.ci_role.arn
}

resource "github_actions_secret" "cloudflare_api_token" {
  for_each = local.repos

  repository      = each.value
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = data.aws_ssm_parameter.cloudflare_api_token.value
}


# Debugging purposes
output "deployable_repos" {
  value = toset(local.repos)
}
