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
  nonprod_include_repos = [
    "docs-internal",
    "^environments$" # strict match to avoid picking poc-environments
  ]

  # Keep repos that match any regex in local.nonprod_include_repos
  nonprod_deployable_repos = toset([
    for repo in data.github_repositories.all_repos.names : repo if anytrue([
      for included_repo in local.nonprod_include_repos : length(regexall(included_repo, repo)) > 0
    ])
  ])
}

## AWS IAM OIDC role arn
resource "github_actions_secret" "oidc_iam_role_for_ci" {
  for_each = local.nonprod_deployable_repos

  repository      = each.value
  secret_name     = "AWS_IAM_OIDC_ROLE_CI"
  plaintext_value = aws_iam_role.github_oidc_mgmt.arn
}

module "cicd_role_nonprod" {
  providers = {
    aws = aws.nonprod
  }

  source = "../modules/ci-role-target-account"

  role_name                 = var.ci_role_name
  role_description          = var.ci_role_description
  role_max_session_duration = var.role_max_session_duration
  role_attach_policies      = var.ci_role_attach_policies

  assume_role_role_arn = aws_iam_role.github_oidc_mgmt.arn
}

## AWS IAM role arn for CI/CD
resource "github_actions_secret" "nonprod_iam_role_for_ci" {
  for_each = local.nonprod_deployable_repos

  repository      = each.value
  secret_name     = "AWS_IAM_ROLE_CI_NONPROD"
  plaintext_value = module.cicd_role_nonprod.role_arn
}

resource "github_actions_secret" "cloudflare_api_token" {
  for_each = local.nonprod_deployable_repos

  repository      = each.value
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = data.aws_ssm_parameter.cloudflare_api_token.value
}


# Debugging purposes
output "nonprod_deployable_repos" {
  value = local.nonprod_deployable_repos
}
