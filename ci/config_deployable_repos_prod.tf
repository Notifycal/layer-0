locals {
  # this array can be used to do partial matches too. ie: `tofu-module-`
  prod_include_repos = [
    "^environments$" # strict match to avoid picking poc-environments
  ]

  # Keep repos that match any regex in local.prod_include_repos
  prod_deployable_repos = toset([
    for repo in data.github_repositories.all_repos.names : repo if anytrue([
      for included_repo in local.prod_include_repos : length(regexall(included_repo, repo)) > 0
    ])
  ])
}

module "cicd_role_prod" {
  providers = {
    aws = aws.prod
  }

  source = "../modules/ci-role-target-account"

  role_name                 = var.ci_role_name
  role_description          = var.ci_role_description
  role_max_session_duration = var.role_max_session_duration
  role_attach_policies      = var.ci_role_attach_policies

  assume_role_role_arn = aws_iam_role.github_oidc_mgmt.arn
}


# AWS IAM role arn for CI/CD
resource "github_actions_secret" "prod_iam_role_for_ci" {
  for_each = local.prod_deployable_repos

  repository      = each.value
  secret_name     = "AWS_IAM_ROLE_CI_PROD"
  plaintext_value = module.cicd_role_prod.role_arn
}

# Debugging purposes
output "prod_deployable_repos" {
  value = local.prod_deployable_repos
}
