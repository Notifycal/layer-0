variable "github_organization_name" {
  type    = string
  default = "Notifycal"
}

locals {
  ignored_repos = [
    ".github-private",
    "ai-wizard-onboarding",
    "event-viewer-ai-bolt.new",
    "event-viewer-ai-lovable.dev",
  ]
  non_poc_research_repos = toset(setsubtract(data.github_repositories.all_repos.names, local.ignored_repos))
}

# The data source will return a maximum of 1000 repositories as documented in official API docs.
data "github_repositories" "all_repos" {
  query           = "org:${var.github_organization_name} archived:false"
  include_repo_id = true
}

output "all_org_repos" {
  value = local.all_repos
}

output "non_poc_research_repos" {
  value = local.non_poc_research_repos
}
