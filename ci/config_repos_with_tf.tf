data "aws_ssm_parameter" "cicd_app_id" {
  name = "/providers/github/app/notifycal-ci-cd/app_id"
}

data "aws_ssm_parameter" "cicd_app_secret" {
  name = "/providers/github/app/notifycal-ci-cd/app_secret"
  # with_decryption = true
}

locals {
  exclude_repos = [
    "test-webapp",
    "tofu-module-",
    "template-",
    "docs-raw"
  ]
  
  # Filter out repos that match any regex in local.exclude_repos
  repos = toset([
    for repo in data.github_repositories.all_repos.names: repo if ! anytrue([
      for excluded_repo in local.exclude_repos: length(regexall(excluded_repo, repo)) > 0
    ])
  ])

  include_branches = [
    "main",
    "master"
  ]
  # This list includes repo and branch
  oidc_repo_list = [for repo in setproduct(local.repos, local.include_branches): "${var.github_organization_name}/${repo[0]}:ref:refs/heads/${repo[1]}"]
}

## Github App secrets
resource "github_actions_secret" "cicd_app_id" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "NOTIFYCAL_CICD_APP_ID"
  plaintext_value  = "860731"
  # plaintext_value  = data.aws_ssm_parameter.cicd_app_id.value
}

resource "github_actions_secret" "cicd_app_secret" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "NOTIFYCAL_CICD_APP_SECRET"
  plaintext_value  = data.aws_ssm_parameter.cicd_app_secret.value
}

## AWS IAM role name for CI/CD
resource "github_actions_secret" "iam_role_for_ci" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "AWS_IAM_ROLE_CI"
  plaintext_value  = aws_iam_role.ci_role.arn
}


# Debugging purposes
output "repos" {
  value = local.repos
}
