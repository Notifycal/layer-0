locals {
  exclude_repos = [
    "test-webapp"
  ]
  repos = setsubtract(data.github_repositories.all_repos.names, local.exclude_repos)
  include_branches = [
    "main",
    "master"
  ]
  # This list includes repo and branch
  oidc_repo_list = [for repo in setproduct(local.repos, local.include_branches): "${var.github_organization_name}/${repo[0]}:ref:refs/heads/${repo[1]}"]
}

variable "github_organization_name" {
  type = string
  default = "Notifycal"
}

# The data source will return a maximum of 1000 repositories as documented in official API docs.
data "github_repositories" "all_repos" {
  query = "org:${var.github_organization_name}"
  include_repo_id = true
}

output "repos" {
  value = local.repos
}

