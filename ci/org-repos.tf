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

