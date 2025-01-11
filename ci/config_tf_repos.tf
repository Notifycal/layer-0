## stuff that's common to all TF repos. 
## For example, TF repos will likely need to access other private TF module repos
## This does not do anything cloud-related

locals {
  # this array can be used to do partial matches too. ie: `tofu-module-`
  include_tf_repos = [
    "docs-internal",
    "static-landing",
    "backend",
    "frontend",
    "^environments$", # strict match to avoid picking poc-environments
    "gh-actions"
  ]

  # Keep repos that match any regex in local.include_repos
  tf_repos = toset([
    for repo in data.github_repositories.all_repos.names : repo if anytrue([
      for included_tf_repo in local.include_tf_repos : length(regexall(included_tf_repo, repo)) > 0
    ])
  ])
}
