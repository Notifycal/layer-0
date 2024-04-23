data "aws_ssm_parameter" "cicd_app_id" {
  name = "/providers/github/app/notifycal-ci-cd/app_id"
}

data "aws_ssm_parameter" "cicd_app_secret" {
  name = "/providers/github/app/notifycal-ci-cd/app_secret"
}

locals {
  # this array can be used to do partial matches too. ie: `tofu-module-`
  include_repos = [
    "docs-internal",
    "environments"
    # infra repo goes here
  ]
  
  # Keep repos that match any regex in local.include_repos
  repos = toset([
    for repo in data.github_repositories.all_repos.names: repo if anytrue([
      for included_repo in local.include_repos: length(regexall(included_repo, repo)) > 0
    ])
  ])

  include_branches = [
    "main",
    "master"
  ]
  # This list includes repo and branch
  oidc_repo_list = [for repo in setproduct(local.repos, local.include_branches): "${var.github_organization_name}/${repo[0]}:ref:refs/heads/${repo[1]}"]
}

## AWS IAM role name for CI/CD
resource "github_actions_secret" "iam_role_for_ci" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "AWS_IAM_ROLE_CI"
  plaintext_value  = aws_iam_role.ci_role.arn
}


# Debugging purposes
output "deployable_repos" {
  value = toset(local.repos)
}
