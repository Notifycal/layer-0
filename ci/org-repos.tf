variable "github_organization_name" {
  type    = string
  default = "Notifycal"
}

# The data source will return a maximum of 1000 repositories as documented in official API docs.
data "github_repositories" "all_repos" {
  query           = "org:${var.github_organization_name} archived:false"
  include_repo_id = true
}

output "all_org_repos" {
  value = toset(data.github_repositories.all_repos.names)
}
